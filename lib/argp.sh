argp:parse() {
    export OPTION=() OPTARG=()
    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            --*)
                export OPTION+=("${1##*"--"}")
                shift
            ;;
            -*)
                export OPTION+=("${1##*"-"}")
                shift
            ;;
            *)
                export OPTARG+=("${1}")
                shift
            ;;
        esac
    done

    if [[ -z "${OPTION[@]}" ]] ; then
        export OPTION="null"
    fi

    if [[ -z "${OPTARG[@]}" ]] ; then
        export OPTARG="null"
    fi
}