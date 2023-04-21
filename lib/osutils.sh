#!/bin/bash

osutils:selectbase() {
    if [[ -f "/etc/os-release" ]] ; then
        source "/etc/os-release"
    	case "${ID}" in
            "debian")
                echo "debian"
            ;;
            "linuxmint"|"ubuntu")
                echo "ubuntu"
            ;;
            "kali")
                echo "kali"
            ;;
            "fedora")
                echo "fedora"
            ;;
            "arch"|"pnm")
                echo "arch"
            ;;
            *)
                echo "unknown distribution."
            ;;
	    esac
    else
        echo "${0##*/}: ${FUNCNAME##*:}: os release file not found."
        return 1
    fi
}

osutils:getpkgs() {
    local _distro_="$(osutils:selectbase)" _pkg_="" _pkgarr_=()
    if ! [[ -f "${1}" ]] ; then
        echo -e "${red}${0##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: \"Gibifile\" doesn't exist."
        return 1
    else
        for _pkg_ in $(parser:depends "${1}" "${_distro_}") ; do
            local _pkgarr_+=("${_pkg_%%:*}")
        done
        if [[ -n "${_pkgarr_[@]}" ]] ; then
            case "${_distro_}" in
                "debian"|"ubuntu"|"kali")
                    apt update && apt install -y "${_pkgarr_[@]}"
                ;;
                "fedora")
                    dnf install -y "${_pkgarr_[@]}"
                ;;
                "arch")
                    pacman -Sy --noconfirm "${_pkgarr_[@]}"
                ;;
            esac
        else
            echo "nothing will install or update."
        fi
    fi
}