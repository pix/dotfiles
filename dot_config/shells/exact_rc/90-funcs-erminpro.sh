# Yes I know this is hacky stuff, I should pay for this tool
#
# shellcheck disable=SC2181
# vim:ft=bash:
#

# doc:function:ermine_pro:shell:Static binary compilation with Magic Ermine Pro.\n  Usage: ermine_pro <source> [destination] [arch]
ermine_pro() {
    local arch="${3:-x86_64}"

    if [[ -z "${TMP_MAGIC_ERMINE}" || ! -f "${TMP_MAGIC_ERMINE}.${arch}" ]]; then
        tmp_ermine=$(mktemp --suffix ErminePro)
        echo "Downloading Magic Ermine Pro to ${tmp_ermine}"
        wget -o /dev/null -O "${tmp_ermine}.${arch}" \
            "http://magicermine.com/trial/ErmineProTrial.${arch}/ErmineProTrial.${arch}/ErmineProTrial.${arch}"

        if [[ $? -ne 0 || ! -f "${tmp_ermine}" ]]; then
            echo "Unable to download ermine_pro"
            return 1
        fi

        chmod a+x "${tmp_ermine}.${arch}"
        export TMP_MAGIC_ERMINE="${tmp_ermine}"
    else
        echo "Reusing cached ${TMP_MAGIC_ERMINE}"
    fi


    SRC="${1}"
    DST="${2}"

    if [ -z "${DST}" ]; then
        DST="${SRC}.static"
    fi

    echo "Statifying \"${SRC}\" to \"${DST}\""
    "${TMP_MAGIC_ERMINE}.${arch}" "${SRC}" --output "${DST}"
    echo "${DST}: $(du -hs "${DST}" | awk '{print $1}')"
}

# doc:function:ermine_x86:shell:Static binary compilation with Magic Ermine Pro for i386.\n  Usage: ermine_x86 <source> [destination]
ermine_x86() {
    ermine_pro "${1}" "${2}" i386
}

# doc:function:ermine_x64:shell:Static binary compilation with Magic Ermine Pro for x64.\n  Usage: ermine_x64 <source> [destination]
ermine_x64() {
    ermine_pro "${1}" "${2}" x86_64
}
