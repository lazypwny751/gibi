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

export isHelp="false" version="0.0.2"

# Function side.
die() {
	printf "%s: \e[1;31merror\e[0m: %s." "${0##*/}" "${1:-unknown}"
	exit "${2:-1}"
}

info() {
	printf "%s: \e[1;34minfo\e[0m: %s." "${0##*/}" "${1:-unknown}"
}

warn() {
	printf "%s: \e[1;33mwarn\e[0m: %s." "${0##*/}" "${1:-unknown}"	
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
	if [ -d "${gdir}/repo/${base}/${repo}" ]
	then
		printf "%s is already clonned, do you want't to reclone it? (y/N):> " "${repo}"
		read -r ask
		case "${ask:-N}" in
			[yY])
				rm -rf "${gdir}/repo/${base}/${repo}"
				git clone "https://${1}.git" "${gdir}/repo/${base}/${repo}" || {
					die "some errors occured wheel cloning \"${repo}\""
				}
			;;
			*) : ;;
		esac
	else
		[ ! -d "${gdir}/repo/${base}" ] && {
			mkdir -p "${gdir}/repo/${base}"
		}
		git clone "https://${1}.git" "${gdir}/repo/${base}/${repo}"
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

# Argument parsing.
while getopts ":d:iuhv" opt
do
	case "${opt}" in
		"d")
			export gdir="${OPTARG}"
		;;
		"i")
			export option="install"
		;;
		"u")
			export option="uninstall"
		;;
		"h")
			export isHelp="true"
		;;
		"v")
			export option="version"
		;;
		*)
			if [ -z "${unknown}" ]
			then
		    	export unknown="${OPTARG}"
		    else
		    	export unknown="${unknown}:${OPTARG}"
			fi
		;;
	esac
done

export gdir="${gdir:-${HOME}/.locale/share/gibi}"

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

# Operations(from option), main side.
case "${option:-}" in
	"install")
		if checkcomm "git" "mkdir"
		then
			[ ! -d "${gdir}" ] && {
				mkdir -p "${gdir}/repo"	
				mkdir -p "${gdir}/bin"
			}

			IFS=":"
			for p in ${pkg}
			do 
				getrepo "${p}"
			done
		fi
	;;
	"uninstall")
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
		echo "${pkg}"
		"${isHelp:-false}" || exit 1 
	;;
esac
