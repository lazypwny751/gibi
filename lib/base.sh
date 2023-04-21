#!/bin/bash

# Reset
reset='\033[0m'           # Text Reset

# Regular Colors
black='\033[0;30m'        # Black
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purple='\033[0;35m'       # Purple
cyan='\033[0;36m'         # Cyan
white='\033[0;37m'        # White

check:entity() {
    local _entity_="" status="true"
    for _entity_ in "${@}" ; do
        if ! [[ -e "${_entity_}" ]] ; then
            echo "${0##*/}: ${FUNCNAME##*:}: file or directory doesn't exist: \"${_entity_}\"."
            local status="false"
        fi
    done

    if ! ${status} ; then
        return 1
    fi
}

check:cmd() {
    local _cmd_="" status="true"
    for _cmd_ in "${@}" ; do
        if ! command -v "${_cmd_}" &> /dev/null ; then
            echo "${0##*/}: ${FUNCNAME##*:}: command not found: \"${_cmd_}\"."
            local status="false"
        fi
    done

    if ! ${status} ; then
        return 1
    fi
}

tmp:manager() {
    if [[ -d "/tmp" ]] ; then
        local TEMPD="/tmp/gibish"
    else
        local TEMPD="${CWD}/.gibitmp"
    fi

    argp:parse "${@}"
    local MOPT="${OPTION[0],,}"

    if [[ "${OPTARG[0],,}" = "null" ]] ; then
        local OPTARG=""
    fi

    case "${MOPT}" in
        "start")
            if [[ -d "${TEMPD}/${OPTARG[0],,}" ]] ; then
                rm -rf "${TEMPD}/${OPTARG[0],,}"
            fi
            mkdir -p "${TEMPD}/${OPTARG[0],,}"
            export TMPDIR="${TEMPD}/${OPTARG[0],,}"
        ;;
        "stop")
            if [[ -d "${TEMPD}/${OPTARG[0],,}" ]] ; then
                rm -rf "${TEMPD}/${OPTARG[0],,}"
            fi
        ;;
        *)
            echo "${0##*/}: ${FUNCNAME##*:}: unknown option: \"${MOPT}\"."
            return 0
        ;;
    esac
}

on:exit() {
    tmp:manager --stop
}