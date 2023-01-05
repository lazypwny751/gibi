#!/bin/bash

#    Very basic package manager written in python3 for bychan projects - bcpm
#    Copyright (C) 2023  lazypwny751
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

# Defining arguments and parameters.
set -e

export status="true"
export PREFIX="/usr"

until (( "${#}" == 0 )) ; do
    case "${1}" in
        --[pP][rR][eE][fF][iI][xX]|"-p")
            shift
            if [[ -n "${1}" ]] ; then
                export PREFIX="${1}"
                shift
            fi
        ;;
        --[wW][oO][rR][kK][dD][iI][rR]|"-w")
            shift
            if [[ -n "${1}" ]] ; then
                export BCPMWORKDIR="${1}"
                shift
            fi        ;;
        --[lL][iI][bB][dD][iI][rR]|"-l")
            shift
            if [[ -n "${1}" ]] ; then
                export BCPMLIBDIR="${1}"
                shift
            fi
        ;;
        *)
            shift
        ;;
    esac
done

# Configuration

# Bcpm root directory, all entities of the project under this path.
if [[ -n "${BCPMWORKDIR}" ]] ; then
    export BCPMWORKDIR="${PREFIX}/${BCPMWORKDIR}"
else
    export BCPMWORKDIR="${PREFIX}/share/bcpm"
fi

# Bcpm library path is under the work directory.
if [[ -n "${BCPMLIBDIR}" ]] ; then
    export BCPMLIBDIR="${BCPMWORKDIR}/${BCPMLIBDIR}"
else
    export BCPMLIBDIR="${BCPMWORKDIR}/lib"
fi

# Bcpm's trigger.
export BCPMBINDIR="${0}"

# Required bcpm files and directories.
export entities=(
    "${BCPMBINDIR}"
    "${BCPMWORKDIR}"
    "${BCPMLIBDIR}"
    "${BCPMWORKDIR}/bcpm.py"
)

# Required bcpm executables.
export commands=(
    "cpio" # alternative archiver is required.
)

for check in "${entities[@]}" ; do
    if ! [[ -e "${check}" ]] ; then
        echo -e "\t\033[0;31m${BASH_SOURCE[0]##*/}\033[0m: file or directory \"${check}\" doesn't exist!"
        export status="false"
    fi
done

for check in "${commands}" ; do
    if ! command -v "${check}" &> /dev/null ; then
        echo -e "\t\033[0;31m${BASH_SOURCE[0]##*/}\033[0m: command \"${check}\" not found!"
        export status="false"
    fi
done

if ! ${status} ; then
    echo -e "\t\033[0;31m${BASH_SOURCE[0]##*/}\033[0m: some entities were not found!"
    exit 1
fi

unset entities commands check

if command -v "python3" &> /dev/null ; then
    :
elif command -v "python" &> /dev/null ; then
    :
else
    echo -e "\033[0;31m${BASH_SOURCE[0]##*/}\033[0m: \033[0;31mFATAL\033[0m: there is no available version of python (required python >= 3.9.x)."
    exit 1
fi