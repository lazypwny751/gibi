init:gibi() {
    set -e
    check:cmd "${require_cmd[@]}"
    check:entity "${entites[@]}"
    if ! [[ -d "${GIBIDIR}" ]] ; then
        mkdir -p "${GIBIDIR}"
    fi

    if ! [[ -d "${GIBIDIR}/meta" ]] ; then
        mkdir -p "${GIBIDIR}/meta"
    fi

    if ! [[ -d "${GIBIDIR}/bin" ]] ; then
        mkdir -p "${GIBIDIR}/bin"
    fi
}