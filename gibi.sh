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

set -e

export isHelp="false"

while getopts ":hv" opt
do
	case "${opt}" in
		"i")
			:
		;;
		"u")
			:
		;;
		"h")
			export isHelp="true"
		;;
	esac
done

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

case "${option:-}" in
	"version")
		printf "."
	;;
	*)
		echo "${pkg}"
		"${isHelp:-false}" || exit 1 
	;;
esac
