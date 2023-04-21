install:install() {
    local _repo_="" status="true"
    for  _repo_ in "${@}" ; do
        read -a _repoarr_ <<< "${_repo_[@]//\//" "}"
        tmp:manager --start "${_repoarr_[-1]}"
        echo -e "\t === ${cyan}${_repoarr_[-1]}${reset} by ${green}${_repoarr_[-2]}${reset} ==="
        git clone "${_repo_}" "${TMPDIR}"
        if [[ -f "${TMPDIR}/Gibifile" ]] ; then
            (
                cd "${TMPDIR}"
                export _pkgver_="$(version:convert "$(parser:version "${TMPDIR}/Gibifile")")"
                export _pkgbuild_="$(parser:build "${TMPDIR}/Gibifile")"
                export _executable_="$(parser:executable "${TMPDIR}/Gibifile")"
                if [[ -f "${_pkgbuild_}" ]] ; then
                    osutils:getpkgs "${TMPDIR}/Gibifile"
                    bash "${_pkgbuild_}" || {
                        echo "${_pkgbuild_##*/}: subprocess failed."
                        exit 1
                    }
                    if ! [[ -d "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}" ]] ; then
                        mkdir -p "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}"
                    fi
                    echo "version=\"${_pkgver_}\"" > "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}/version"
                    # Everything is file
                    echo "entities=(" > "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}/entities"
                    for _everyfile_  in $(find . ! -name "${_pkgbuild_}" ! -name "Gibifile" ! -name ".") ; do
                        if [[ -d "${_everyfile_}" ]] && [[ ! -d "${_everyfile_#*.}" ]] ; then
                            mkdir -p "${_everyfile_#*.}"
                        elif [[ -f "${_everyfile_}" ]] && [[ ! -f "${_everyfile_#*.}" ]] ; then
                            cp "${_everyfile_}" "${_everyfile_#*.}"
                        fi
                        echo -e "\t\"${_everyfile_#*.}\"" >> "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}/entities"
                    done
                    echo ")" >> "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}/entities"
                else
                    echo "${0##*/}: ${FUNCNAME##*:}: build file doesn't exist: \"${_pkgbuild_}\"."
                    exit 1
                fi
                echo -e "executable=\"${_executable_}\"" > "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}/exec"
                source "${GIBIDIR}/meta/${_repoarr_[-2]}/${_repoarr_[-1]}/exec"
                if [[ -f "${executable}" ]] ; then
                    chmod u+x "${executable}"
                    if ! [[ -f "${GIBIDIR}/bin/${executable##*/}" ]] ; then
                        ln "${executable}" "${GIBIDIR}/bin/${executable##*/}"
                        echo -e "${green}${GIBIDIR}/bin/${executable##*/}${reset}"
                    fi
                fi
            )
        else
            echo -e "${red}${0##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: \"Gibifile\" doesn't exist."
            local status="false"
        fi
        tmp:manager --stop "${_repoarr_[-1]}"
    done
    on:exit
    if ! ${status} ; then
        return 1
    fi
}