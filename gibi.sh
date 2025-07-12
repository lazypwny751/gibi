#!/bin/sh

#    Git based innovative package manager written in posix shell - part of bychan's tool kit.
#    Copyright (C) 2023  ByCh4n&lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

export isHelp="false" version="2.0.0"

# Function side.
error() {
	printf "%s: \e[1;31merror\e[0m: %s.\n" "${0##*/}" "${1:-unknown}"
	return "${2:-1}"
}

die() {
	printf "%s: \e[1;31mfatal\e[0m: %s.\n" "${0##*/}" "${1:-unknown}"
	exit "${2:-1}"
}

info() {
	printf "%s: \e[1;34minfo\e[0m: %s.\n" "${0##*/}" "${1:-unknown}"
}

warn() {
	printf "%s: \e[1;33mwarn\e[0m: %s.\n" "${0##*/}" "${1:-unknown}"
	return "${2:-0}"	
}

checkcomm() {
	statement="true"
	for i in "${@}"
	do
		if ! command -vV "${i}"
		then
			statement="false"
		fi
	done

	if ! "${statement}"
	then
		return 1
	fi
}

getnet() {
	[ "${#}" -lt 2 ] && {
		warn "please give \$1(which is a url) and \$2(is a download path)."
		return 1
	}

	client="none"
	for c in "curl" "wget"
	do
		if command -vV "${c}"
		then
			client="${c}"
			break
		fi
	done

	case "${client}" in
		"curl")
			curl -sSL "${1}" -o "${2}"			
		;;
		*)
			die "unknown http client, please install \"curl\" or \"wget\""
		;;
	esac
}

getrepo() {
	[ "${#}" -lt 1 ] && {
		warn "please give the repository url."
		return 1
	}

	repo="${1##*/}"
	base="${1%/*}"
	base="${base##*/}"
	if [ -d "${gdir}/pkg/${base}/${repo}" ]
	then
		git -C "${gdir}/pkg/${base}/${repo}" pull
	else
		[ ! -d "${gdir}/pkg/${base}" ] && {
			mkdir -p "${gdir}/pkg/${base}"
		}
		git clone "https://${1}.git" "${gdir}/pkg/${base}/${repo}"
	fi
}

verscore() {
    IFS="."

	# shellcheck disable=SC2086
	set -- ${1}
    unset IFS

    maj="${1}"
    min="${2}"
    pat="${3}"

    case $maj in *[!0-9]* | '') maj=0 ;; esac
    case $min in *[!0-9]* | '') min=0 ;; esac
    case $pat in *[!0-9]* | '') pat=0 ;; esac

    echo "$(( 1000 * maj + 100 * min + 10 * pat ))"
}

# Version compare.
# usage:
# > vercomp "1.2.3" "1.2.4"
# < 0 if first is less than second, 1 if first is greater than second
vercomp() {
	## Version compare.
	[ "${#}" -lt 2 ] && {
		warn "please give primary and secondary version numbers."
		return 1
	}

	# shellcheck disable=SC2086
	if [ "$(verscore ${1})" -gt "$(verscore ${2})" ]
	then
		return 0
	else
		return 1
	fi
}

# Check if section exists in a file.
# usage:
# > sectionlookup "<filepath>" "section name"
# < 0 if exists, 1 if not.
sectionlookup() {
	## Sections can define only one time.
	[ "${#}" -lt 2 ] && {
		warn "please give primary and filepath and section name."
		return 1
	}

	if [ -f "${1}" ]
	then
		while IFS= read -r line
		do
			case "${line}" in
				*\[*"${2}"*\]*)
					return 0
				;;
			esac
		done < "${1}"
		return 1
	else
		warn "file \"${1##*/}\" not found"
		return 1
	fi	
}

# Parse section and return lines.
# usage:
# > parsesectionel "<filepath>" "section name"
# > ...
parsesectionel() {
	[ "${#}" -lt 2 ] && {
		warn "please give primary and filepath and section name."
		return 1
	}

	if [ -f "${1}" ]
	then
		inSection="false"
		while IFS= read -r line
		do
			case "${line}" in
				*\[*"${2}"*\]*)
					inSection="true"
				;;
				*\[*\]*)
					if "${inSection}"
					then
						break
					fi
				;;
				*)
					if "${inSection}"
					then
						echo "${line}"
					fi
				;;
			esac
		done < "${1}"
	else
		warn "file \"${1##*/}\" not found"
		return 1
	fi	
}

# Lookup a key in a line.
# usage:
# > keylookup "key=value" "key"
# < value if found, 1 if not.
keylookup() {
	[ "${#}" -lt 2 ] && {
		warn "please give primary and filepath and key name."
		return 1
	}
	line="${1}"
	line="${line#"${line%%[![:space:]]*}"}"
	key="${line%%=*}"
	key="${key%"${key##*[![:space:]]}"}"
	key="${key#"${key%%[![:space:]]*}"}"
	if [ "${key}" = "${2}" ]
	then
		return 0
	else
		return 1
	fi
}

# Get key and value from a line.
# usage: 
# > getkeyvalue "key=value" "key"
# < value
# > getkeyvalue "key=value" "value"
# < key
getkeyvalue() {
	line="${1}"
	line="${line#"${line%%[![:space:]]*}"}"

	key="${line%%=*}"
	value="${line#*=}"

	key="${key%"${key##*[![:space:]]}"}"
	key="${key#"${key%%[![:space:]]*}"}"

	value="${value%"${value##*[![:space:]]}"}"
	value="${value#"${value%%[![:space:]]*}"}"

	case "${2}" in
		"${key}")
			echo "${value}"
		;;
		*)
			echo "${key}"
		;;
	esac
}

installFromFiles() {
	for o in "${@}"
	do
		if [ -f "${o}" ]
		then
			cache_dir="${gdir}/cache/${o##*/}"
			if [ ! -d "${cache_dir}" ]
			then
				mkdir -p "${cache_dir}"
			fi

			echo "./${o%/*}"
			if [ ! -d "${cache_dir}/source" ]
			then
				ln -f "${o}" "${cache_dir}/source"
			fi

			cp "${o}" "${cache_dir}/gibi.cfg"

			[ -f "${cache_dir}/gibi.cfg" ] && echo "" >> "${cache_dir}/gibi.cfg"
			{
				sectionlookup "${cache_dir}/gibi.cfg" "meta" || { 
					warn "meta field not found."
					fail="1"
				}
				sectionlookup "${cache_dir}/gibi.cfg" "build" || { 
					warn "build field not found."
					fail="1"
				}

				if [ "${fail:-0}" != "0" ]
				then
					false
				fi
			} || { 
				error "required field(s) are not found."
				continue
			}

			# meta section header.
			echo "#!/bin/sh" > "${cache_dir}/meta.sh"
			echo "# Generated by gibi.sh" >> "${cache_dir}/meta.sh"
			echo "# Do not edit this file." >> "${cache_dir}/meta.sh"
			echo "" >> "${cache_dir}/meta.sh"

			# build section header.
			echo "#!/bin/sh" > "${cache_dir}/build.sh"
			echo "# Generated by gibi.sh" >> "${cache_dir}/build.sh"
			echo "# Do not edit this file." >> "${cache_dir}/build.sh"
			echo "" >> "${cache_dir}/build.sh"
			echo "set -e" >> "${cache_dir}/build.sh"
			echo "" >> "${cache_dir}/build.sh"
			echo "readonly GIBI_BUILD=\"${cache_dir}/source\"" >> "${cache_dir}/build.sh"
			echo "" >> "${cache_dir}/build.sh"

			parsesectionel "${cache_dir}/gibi.cfg" "meta" | while IFS= read -r line
			do
				case "${line}" in
					"name"*)
						if keylookup "${line}" "name"
						then
							echo "name=\"$(getkeyvalue "${line}" "name")\"" >> "${cache_dir}/meta.sh"
						fi
					;;
					"version"*)
						if keylookup "${line}" "version"
						then
							echo "version=\"$(getkeyvalue "${line}" "version")\"" >> "${cache_dir}/meta.sh"
						fi
					;;
					"description"*)
						if keylookup "${line}" "description"
						then
							echo "description=\"$(getkeyvalue "${line}" "description")\"" >> "${cache_dir}/meta.sh"
						fi
					;;
					"author"*)
						if keylookup "${line}" "author"
						then
							echo "author=\"$(getkeyvalue "${line}" "author")\"" >> "${cache_dir}/meta.sh"
						fi
					;;
				esac
			done

			parsesectionel "${cache_dir}/gibi.cfg" "build" | while IFS= read -r line
			do
				echo "${line}" >> "${cache_dir}/build.sh"
			done
		else
			error "file \"${o}\" not found."
		fi
	done
}

# Argument parsing.
while getopts ":d:irhv" opt
do
	case "${opt}" in
		"d")
			export gdir="${OPTARG}"
		;;
		"i")
			export option="install"
		;;
		"r")
			export option="remove"
		;;
		"h")
			export isHelp="true"
		;;
		"v")
			export option="version"
		;;
		*)
			export fail="1"
			error "unknown option ${OPTARG}, please type, \"${0##*/} -h\" for more information."
		;;
	esac
done

if [ "${fail:-0}" != "0" ]
then
	exit 1
fi

export gdir="${gdir:-${HOME}/.local/share/gibi}"

shift $((OPTIND - 1))
if [ "${#}" -gt 0 ]
then
	for arg in "${@}"; do
		if [ -z "${pkg}" ]
		then
	    	export pkg="${arg}"
	    else
	    	export pkg="${pkg}:${arg}"
		fi
	done
fi

# main section.
case "${option}" in
	"install")
		if checkcomm "git" "mkdir" "ln"
		then
			[ ! -d "${gdir}" ] && {
				mkdir -p "${gdir}/pkg"	
				mkdir -p "${gdir}/bin"
				mkdir -p "${gdir}/cache"
			}

			IFS=":"
			for p in ${pkg}
			do
				if [ -f "${p}" ]
				then
					installFromFiles "${p}"
				fi
			done
		fi
	;;
	"remove")
		if checkcomm "rm"
		then
			IFS=":"
			for p in ${pkg}
			do
				echo "package: ${p}"
			done
		fi
	;;
	"version")
		echo "${version}"
	;;
	*)
		# "${isHelp:-false}" || error "unknown option"
		printf "gibi.sh - ByCh4n's experimental package installer (like, kinda)\n\n"
		printf "Usage:\n"

		printf "  ./gibi.sh -d <dir>          Setup directory\n"
		printf "  ./gibi.sh -i <pkg> [...]    Install one or more packages\n"
		printf "  ./gibi.sh -r <pkg> [...]    Remove one or more packages\n"
		printf "  ./gibi.sh -v                Show version\n"
		printf "  ./gibi.sh -h                Show this help\n\n"

		printf "Package format:\n"
		printf "  site.domain/user/repo     e.g. github.com/bych4n/hello\n\n"

		printf "Note:\n"
		printf "  Yilmaz, ersoy, ilkkan = gibi.\n"
		printf "  Maybe one day but not today..\n"
		"${isHelp:-false}" || exit 1 
	;;
esac
