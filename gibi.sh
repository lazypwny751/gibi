#!/bin/bash

#    Git based innovative package manager written in bash 5.1.16 - a part of ByCh4n's multi Hack Tool kit
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

# TODO:
#	- add http 2 https converter for curl.
#	- add another web clients like wget.
#	- make better user interface.
#	- make modular it.
#	- add policy kit (sudo, doas, pkexec) for now we're using sudo but we will fix it.

set -e

# Define variables and functions
export status="true" option="help" CWD="${PWD}" OPTARG=() GIBIFILE=()
readonly CWD

if [[ -z "${GIBIDIR}" ]] ; then
	export GIBIDIR="${CWD}/packages"
fi

COMMANDS=(
	"rm"
	"git"
	"curl"
	"mkdir"
)

for _chkcmd_ in "${COMMANDS[@]}" ; do
	if ! command -v "${_chkcmd_}" &> /dev/null ; then
		echo -e "\trequired command not found in path: \"${_chkcmd_}\""
		export status="false"
	fi
done

if ! ${status} ; then
	exit 1
fi

# Defining functions.
gibi:ver() {
	set +e
	ver:convert() {
		local _conv_=() ver="0" multiplier="1"
		if [[ -n "${1}" ]] ; then
			read -a _conv_ <<< "${1//"."/" "}"
			for null in $(seq 2 ${#_conv_[@]}) ; do
				local multiplier="$((multiplier * 10))"
			done

			for i in "${_conv_[@]}" ; do
				local num="$((multiplier * i))"
				local multiplier="$((multiplier / 10))"
				local ver="$((ver + num))"
			done
			if [[ -n "${ver}" ]] ; then
				echo "${ver}"
			else
				return 2
			fi
		else
			return 1
		fi
	}

	case "${1}" in
		"compare")
			shift
			if [[ -n "${1}" ]] && [[ -n "${2}" ]] ; then
				if [[ "${1}" -gt "${2}" ]] ; then
					echo "greater"
				elif [[ "${1}" -eq "${2}" ]] ; then
					echo "equal"
				elif [[ "${1}" -lt "${2}" ]] ; then
					echo "little"
				else
					return 1
				fi
			else
				echo "insufficient parameter!"
				return 1
			fi
		;;
		*)
			if [[ -n "${1}" ]] ; then
				ver:convert "${1}" || return 1
			else
				echo "need a parameter!"
				return 1
			fi
		;;
	esac
}

gibi:get() {
	set +e
	unset ver repo entrypoint require_debian require_ubuntu require_kali require_fedora require_arch
	local i="" version="" status="true" _repo_=()

	if [[ -f "${1}" ]] ; then
		source "${1}"
		for i in "ver" "repo" "entrypoint" ; do
			if [[ -z "${!i}" ]] ; then
				echo "required function is empty in \"${1##*/}\": ${i}."
				local status="false"
			fi
		done		

		if ! ${status} ; then
			return 1
		fi

		if gibi:ver "${ver}" 1> /dev/null ; then
			local version="$(gibi:ver "${ver}")"
		else
			echo "ver variable isn't set correctly!"
			return 1
		fi

		read -a _repo_ <<< "${repo//"/"/" "}"

		if [[ -f "/etc/os-release" ]] ; then
			source "/etc/os-release"
			case "${ID}" in
				"debian")
					export distro="debian"
					declare -a require=("${require_debian[@]}")
				;;
				"linuxmint"|"ubuntu")
					local distro="ubuntu"
					declare -a require=("${require_ubuntu[@]}")
				;;
				"kali")
					local distro="kali"
					declare -a require=("${require_kali[@]}")
				;;
				"fedora")
					local distro="fedora"
					declare -a require=("${require_fedora[@]}")
				;;
				"arch"|"pnm")
					local distro="arch"
					declare -a require=("${require_arch[@]}")
				;;
				*)
					echo "unknown distribution."
				;;
			esac
		fi

		if ! [[ -f "${GIBIDIR}/sources/${_repo_[-2]}/${_repo_[-1]}.gibim" ]] ; then
			set -e
			mkdir -p "${GIBIDIR}/sources/${_repo_[-2]}"
			if [[ -n "${require[@]}" ]] ; then
				local pkgs=()
				for _pkg_ in "${require[@]}" ; do
					read -a _setpkg_ <<< "${_pkg_//":"/" "}"
					local pkgs+=("${_setpkg_[0]}")
				done 
				case "${distro}" in
					"debian"|"ubuntu"|"kali")
						sudo apt update && sudo apt install -y "${pkgs[@]}"
					;;
					"arch")
						sudo pacman -Sy --noconfirm "${pkgs[@]}"
					;;
					"fedora")
						sudo dnf makecache --refresh && sudo dnf install -y "${pkgs[@]}"  
					;;
				esac
			fi

			if ! [[ -d "${GIBIDIR}/sources/${_repo_[-2]}/${_repo_[-1]}" ]] ; then
				git clone "${repo}" "${GIBIDIR}/sources/${_repo_[-2]}/${_repo_[-1]}"
			fi

			echo -e "setver=\"${version}\"\nrepo=\"${repo}\"\n" # > "${GIBIDIR}/sources/${_repo_[-2]}/${_repo_[-1]}.gibim"
		else
			echo "already exist."
		fi
	else
		echo "there is no file sourcable at \"${1}\"."
		return 1
	fi
}

# Parsing parameters.
while [[ "${#}" -gt 0 ]] ; do
	# Aliasing long parameters.
	case "${1}" in
		"--directory"|"-dir")
			shift
			if [[ -d "${1}" ]] ; then
				export GIBIDIR="${1}"
				shift
			fi
		;;
		"--install"|"-it")
			export option="install"
			shift
		;;
		"--uninstall"|"-ut")
			export option="uninstall"
			shift
		;;
		"--execute"|"-ex")
			export option="execute"
			shift
		;;
		"--help"|"-hp")
			export option="help"
			shift
		;;
		*)
			export OPTARG+=("${1}")
			shift
		;;
	esac
done

# Process the selected option.
case "${option}" in
	"install")
		set +e
		readonly GIBIDIR

		if [[ -d "${CWD}/.TMP/gibi" ]] ; then
			rm -rf "${CWD}/.TMP/gibi"
		fi

		mkdir -p "${CWD}/.TMP/gibi"

		if [[ -n "${OPTARG[@]}" ]] ; then
			for _anyopt_ in "${OPTARG[@]}" ; do
				if [[ -f "${_anyopt_}" ]] ; then
					export GIBIFILE+=("${_anyopt_}")
				elif [[ "${_anyopt_%:*}" = "https" ]] || [[ "${_anyopt_%:*}" = "http" ]]  ; then
					if curl -s "${_anyopt_}" > "${CWD}/.TMP/gibi/${_anyopt_##*/}" ; then
						export GIBIFILE+=("${CWD}/.TMP/gibi/${_anyopt_##*/}")
					else
						echo -e "\tcurl couldn't get the file, please check ssl or connection."
						export status="false"
					fi
				else
					echo -e "\tcouldn't parsing the option: \"${_anyopt_}\"."
				fi
			done
		else
			echo -e "\tplease give package info file or link: ${0##*/} --${option} \"./pkg.gibi\" \"https://raw.githubusercontent.com/user/repo/main/pkg.gibi\""
			exit 1
		fi

		for _gibifile_ in "${GIBIFILE[@]}" ; do
			(
				gibi:get "${_gibifile_}"
			)
		done

		rm -rf "${CWD}/.TMP/gibi"
		rmdir "${CWD}/.TMP" 2> /dev/null
		exit 0 
	;;
	"uninstall")
		:
	;;
	"execute")
		:
	;;
	"help")
		:
	;;
	*)
		echo "there is no option like \"${option}\"."
		exit 1
	;;
esac