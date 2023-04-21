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
#	- add policy kit (sudo, doas, pkexec) for now we're using sudo but we will fix it.
#	- make implemented source manager.

set -e

# Define variables and functions
export status="true" CWD="${PWD}"
export LIBDIR="${CWD}/lib"
if [[ -z "${GIBIDIR}" ]] ; then
	export GIBIDIR="${CWD}/packages"
fi

export require_cmd=(
	"chmod"
	"mkdir"
	"rmdir"
	"find"
	"awk"
	"git"
	"cp"
	"rm"
	"ln"
)

export require_lib=(
	"base"
	"argp"
	"parser"
	"version"
	"osutils"
	"install"
	"init"
)

export entites=(
	"${CWD}/lib"
	"${CWD}/lib/argp.sh"
	"${CWD}/lib/init.sh"
	"${CWD}/lib/base.sh"
	"${CWD}/lib/parser.sh"
	"${CWD}/lib/version.sh"
	"${CWD}/lib/osutils.sh"
	"${CWD}/lib/install.sh"
)

readonly CWD LIBDIR

for _file_ in "${require_lib[@]}" ; do
	if [[ -f "${LIBDIR}/${_file_}.sh" ]] ; then
		source "${LIBDIR}/${_file_}.sh"
	elif [[ -f "${LIBDIR}/${_file_}" ]] ; then
		source "${LIBDIR}/${_file_}"
	else
		echo -e "file not found: \"${_file_##*/}\"."
		export status="false"
	fi
done

if ! ${status} ; then
	exit 1
fi

# Parsing parameters and initialize the tool.
init:gibi
trap on:exit INT

readonly GIBIDIR

while [[ "${#}" -gt 0 ]] ; do
	case "${1}" in
		"--"[iI][nN][sS][tT][aA][lL][lL]|"-"[iI][nN])
			export OPT="install"
			shift
		;;
		"--"[uU][nN][iI][nN][sS][tT][aA][lL][lL]|"-"[uU][nN])
			export OPT="uninstall"
			shift
		;;
		*)
			export OPTARG+=("${1}")
			shift
		;;
	esac
done

# Processing the option.
case "${OPT}" in
	"install")
		set +e
		install:install "${OPTARG[@]}"
	;;
	"uninstall")
		set +e
	;;
	*)
		echo "${0##*/}: unknown option: \"${OPTION}\"."
		exit 1
	;;
esac