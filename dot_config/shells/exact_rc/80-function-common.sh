#
# Some usefull functions
# vi:ft=bash:
#

# doc:function:sanitize-perms:shell:Sanitize permissions and ownership of files and directories.
sanitize-perms() {
  if [ $# -ne 0 ]; then
    sudo chmod -Rv a-rwX,u+rwX $*
    sudo chown -Rv ${USER}":users" $*
  else
    sudo chmod -Rv a-rwX,u+rwX ./
    sudo chown -Rv ${USER}":users" ./
  fi
}

# doc:function:mkcd:shell:Create a directory and change into it.
mkcd() {
  mkdir "$1" && cd "$1"
}

# alias ssh in kitty
if [[ "$TERM" = "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
  alias diff="kitty +kitten diff"
fi

# doc:function:paste.sh:shell:Encrypt and paste files to paste.sh service.
paste_sh() {
  local HOST=https://paste.sh
  local TMPTMPL=paste.XXXXXXXX
  local VERSION=v2

  die() {
    echo "${1}" >&2
    return ${2:-1}
  }

  randbase64() {
    openssl rand -base64 $1 2>/dev/null | tr '+/' '-_'
  }

  writekey() {
    echo "${id}${serverkey}${clientkey}https://paste.sh"
  }

  generate_oneliner() {
    local url="$1"
    local full_key="$2"
    echo "curl -fsS ${url}.txt|tail -n+2|openssl enc -d -aes-256-cbc -md sha512 -pass pass:${full_key} -base64 -iter 1"
    echo "wget -qO- ${url}.txt|tail -n+2|openssl enc -d -aes-256-cbc -md sha512 -pass pass:${full_key} -base64 -iter 1"
  }

  encrypt() {
    local cmd arg id clientkey header
    cmd="$1"
    arg="$2"
    id="$3"
    clientkey="$4"
    header="$5"

    if [[ -z ${id} ]]; then
      id="$(randbase64 6)"
      if [[ $public == 1 ]]; then
        clientkey=
        id="p${id}"
      fi
    fi

    if [[ $public == 0 ]]; then
      if [[ -z $clientkey ]]; then
        clientkey="$(randbase64 18)"
        serverkey="$(randbase64 18)"
      fi
    fi

    pasteauth=""
    if [[ -f "$HOME/.config/paste.sh/auth" ]]; then
      pasteauth="$(<$HOME/.config/paste.sh/auth)"
    fi

    file=$(mktemp -t $TMPTMPL)
    trap 'rm -f "${file}"' EXIT

    (
      echo -n "${header}${header:+$'\n\n'}"
      $cmd "$arg"
    ) |
      3<<<"$(writekey)" openssl enc -aes-256-cbc -md sha512 -pass fd:3 -iter 1 -base64 >| "${file}"

    echo "Encrypting paste: ${id} (server key: ${serverkey}) (client key: ${clientkey})" >&2

    (curl -sS -o /dev/fd/3 -H "X-Server-Key: ${serverkey}" \
      -H "Content-type: text/vnd.paste.sh-${VERSION}" \
      -T "${file}" "${HOST}/${id}" -b "$pasteauth" -w '%{http_code}' |
      grep -q 200) 3>&1 || die "Unable to post file" $?

    echo "${HOST}/${id}${clientkey:+#}${clientkey}"
    if [[ $public == 0 ]]; then
        generate_oneliner "${HOST}/${id}" "$(writekey)"
    fi
  }

  remove_header() {
    awk 'i == 1 { print }; /^\r?$/ { i=1 }'
  }

  decrypt() {
    local url id clientkey
    url="$1"
    id="$2"
    clientkey=$3
    tmpfile=$(mktemp -t $TMPTMPL)
    headfile=$(mktemp -t $TMPTMPL)
    trap 'rm -f "${tmpfile}" "${headfile}"' EXIT
    curl -fsS -o "${tmpfile}" -H "Accept: text/plain, text/vnd.paste.sh-v2, text/vnd-paste.sh-v3" \
      -D "${headfile}" "${url}.txt" || die "Unable to fetch paste" $?
    serverkey=$(head -n1 "${tmpfile}")
    ct="$(grep -i '^content-type:' ${headfile} | cut -d':' -f2)"
    remove=cat
    ITERS=1
    if [[ $ct = *text/plain* ]]; then
      ITERS="0"
    elif [[ $ct = *text/vnd.paste.sh-v3* ]]; then
      remove=remove_header
    fi
    echo "Decrypting paste: ${url} (server key: ${serverkey}) (client key: ${clientkey})" >&2
    tail -n +2 "${tmpfile}" | openssl enc -d -aes-256-cbc -md sha512 -pass fd:3 -iter $ITERS -base64 3<<<"$(writekey)" | $remove
    return $?
  }

  openssl version &>/dev/null || die "Please install OpenSSL" 127
  curl --version &>/dev/null || die "Please install curl" 127

  fsize() {
    local file="$1"
    stat --version 2>/dev/null | grep -q GNU
    local gnu=$((!$?))

    if [[ $gnu = 1 ]]; then
      stat -c "%s" "$file"
    else
      stat -f "%z" "$file"
    fi
  }

  if [ -z "$TMPDIR" -a -w /dev/shm ]; then
    export TMPDIR=/dev/shm
  fi

  public=0
  header=""
  main() {
    if [[ $# -gt 0 ]]; then
      if [[ ${1:0:8} = https:// ]] || [[ ${1:0:17} = http://localhost: ]]; then
        url=$(cut -d'#' -f1 <<<"$1")
        id=$(cut -d/ -f4 <<<"${url}")
        clientkey=$(cut -sd'#' -f2 <<<"$1")
        if [[ $# -eq 1 ]]; then
          decrypt "$url" "$id" "$clientkey"
        else
          shift
          main "$@"
        fi
      elif [[ ${1} == "-i" ]]; then
        mkdir -p "$HOME/.config/paste.sh"
        umask 0277
        (
          echo -n pasteauth=
          randbase64 18
        ) >"$HOME/.config/paste.sh/auth"
      elif [[ ${1} == "-h" ]] || [[ ${1} == "--help" ]]; then
        cat <<EOF
Usage: paste.sh [options] [file]
  Send clipboard:
    $ paste.sh
  Send output of command:
    $ foo 2&>1 | paste.sh
  Paste file:
    $ paste.sh some-file
  Add title to paste:
    $ paste.sh -s "Some cool paste"
  Public paste (shorter URL, as no encryption, limited to command line client
  for now):
    $ paste.sh -p [same usage as above]
  Print paste:
    $ paste.sh 'https://paste.sh/xxxxx#xxxx'
    (You need to quote or escape the URL due to the #)
  The command line client by default does not store an identifiable cookie
  with pastes, you can run "paste.sh -i" to initialise a cookie, which means
  you can then update pastes:
    paste.sh 'https://paste.sh/xxxxx#xxxx' some-file

Options:
    -i          Initialize paste.sh auth
    -H <host>   Use a different paste.sh host
    -p          Make the paste public
    -s <subject>  Set the subject of the paste
    -t <type>   Set the content type of the paste
EOF
      elif [[ ${1} == "-H" ]]; then
        shift
        HOST=$1
        shift
        main "$@"
      elif [[ ${1} == "-p" ]]; then
        shift
        public=1
        main "$@"
      elif [[ ${1} == "-s" ]]; then
        shift
        VERSION="v3"
        header="$(printf "Subject: %s\n%s" "$1" "$header")"
        shift
        main "$@"
      elif [[ ${1} == "-t" ]]; then
        shift
        VERSION="v3"
        header="$(printf "Content-Type: %s\n%s" "$1" "$header")"
        shift
        main "$@"
      elif [[ ${1} == "-v" ]]; then
        shift
        VERSION="v${1}"
        shift
        main "$@"
      elif [[ ${1} == "--" ]]; then
        shift
        main "$@"
      elif [ -e "${1}" -o "${1}" == "-" ]; then
        if [ "${1}" != "-" ] && [ "$(fsize "${1}")" -gt $((1024 * 1024)) ]; then
          die "${1}: File too big"
        fi
        encrypt "cat --" "$1" "$id" "$clientkey" "$header"
      else
        echo "$1: No such file and not a URL"
        return 1
      fi
    elif ! [ -t 0 ]; then
      encrypt cat "-" "$id" "$clientkey" "$header"
    elif [[ $(uname) = Darwin ]]; then
      encrypt pbpaste "" "$id" "$clientkey" "$header"
    elif [[ -n $WAYLAND_DISPLAY ]]; then
      encrypt wl-paste "-n" "$id" "$clientkey" "$header"
    elif [[ -n $DISPLAY ]]; then
        encrypt xsel "-o" "$id" "$clientkey" "$header"
    else
      echo "paste.sh client -- no clipboard available"
      echo "Try: $0 file"
    fi
  }
  main "$@"
}

# alias kitty clipboard commands
if [[ -n "$SSH_CONNECTION" ]] && [[ "$PATH" == *kitty-ssh-kitten* ]]; then
    wl-copy() {
        local opt
        local clipboard_type=""
        local mime_type=""
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -p|--primary)
                    clipboard_type="-p"
                    shift
                    ;;
                -t|--type)
                    mime_type="$2"
                    shift 2
                    ;;
                -h|--help)
                    echo "Usage: wl-copy [options] < file-to-copy"
                    echo "Options:"
                    echo "  -p, --primary    Use the 'primary' clipboard."
                    echo "  -t, --type       Override the inferred MIME type for the content."
                    exit 0
                    ;;
                *)
                    echo "Unsupported option: $1"
                    exit 1
                    ;;
            esac
        done
        
        if [[ -n "$mime_type" ]]; then
            kitten clipboard --mime "$mime_type" $clipboard_type
        else
            kitten clipboard $clipboard_type
        fi
    }

    wl-paste() {
        local clipboard_type=""
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -p|--primary)
                    clipboard_type="-p"
                    shift
                    ;;
                -h|--help)
                    echo "Usage: wl-paste [options]"
                    echo "Options:"
                    echo "  -p, --primary    Use the 'primary' clipboard."
                    exit 0
                    ;;
                *)
                    echo "Unsupported option: $1"
                    exit 1
                    ;;
            esac
        done
        
        kitten clipboard --get-clipboard $clipboard_type
    }
fi
