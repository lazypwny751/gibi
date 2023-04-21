parser:version() {
    local version=""
    if [[ -f "${1}" ]] ; then
        local version="$(awk -f "${LIBDIR}/parser/version.awk" "${1}")"
        echo "${version#*" "}"
    else
        echo "${0##*/}: ${FUNCNAME##*:}: file not found: \"${1##*/}\"."
        return 1
    fi
}

parser:executable() {
    local executable=""
    if [[ -f "${1}" ]] ; then
        local executable="$(awk -f "${LIBDIR}/parser/executable.awk" "${1}")"
        echo "${executable#*" "}"
    else
        echo "${0##*/}: ${FUNCNAME##*:}: file not found: \"${1##*/}\"."
        return 1
    fi
}

parser:build() {
    local build=""
    if [[ -f "${1}" ]] ; then
        local build="$(awk -f "${LIBDIR}/parser/build.awk" "${1}")"
        echo "${build#*" "}"
    else
        echo "${0##*/}: ${FUNCNAME##*:}: file not found: \"${1##*/}\"."
        return 1
    fi
}

parser:depends() {
    if ! [[ -f "${1}" ]] ; then
        echo "${0##*/}: ${FUNCNAME##*:}: file not found: \"${1##*/}\"."    
        return 1
    elif [[ -z "${2}" ]] ; then
        echo "${0##*/}: ${FUNCNAME##*:}: need an option."
        return 1
    else
        awk -v opt="${2}" -f "${LIBDIR}/parser/depends.awk" "${1}"
    fi
}