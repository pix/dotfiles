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
