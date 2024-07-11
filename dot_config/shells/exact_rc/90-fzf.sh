function fzf-man() {
  batman="man {1} | col -bx | bat --language=man --plain --color always"
   man -k . | sort \
   | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue;} 1' \
   | fzf  \
      -q "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > '  \
      --preview-window '50%,rounded,<50(up,85%,border-bottom)' \
      --preview "${batman}" \
      --bind "enter:execute(man {1})" \
      --bind "alt-c:+change-preview(cht.sh {1})+change-prompt(ﯽ Cheat > )" \
      --bind "alt-m:+change-preview(${batman})+change-prompt( Man > )" \
      --bind "alt-t:+change-preview(tldr {1})+change-prompt(ﳁ TLDR > )"

  if [[ -n $ZSH_VERSION ]]; then
    zle reset-prompt
  fi
}
# doc:function:fzman:shell:Show a man (alt-m), tldr (alt-t) or cheat (alt-c) page in fzf.
alias fzman=fzf-man

# doc:function:fzjq:shell:Interactive jq filtering. (alt-c: copy to clipboard)
function fzjq() { # jq interactive filtering
  local JQ_PREFIX
  local INITIAL_QUERY
  local file

  # if input is a file then cat it, otherwise save it to a temporary file
  if [ -n "$*" ]; then
    JQ_PREFIX=" cat $@ | jq -C "
  else
    file=$(mktemp)
    set -o localoptions -o localtraps
    trap 'rm -f $file' EXIT
    dd of=$file 2>/dev/null || true
    JQ_PREFIX=" cat $file | jq -C "
  fi
  INITIAL_QUERY="."
  FZF_DEFAULT_COMMAND="$JQ_PREFIX '$INITIAL_QUERY'" fzf --no-sort --no-sort \
    --bind "change:reload:$JQ_PREFIX {q} | tac || true" \
    --bind "ctrl-r:reload:$JQ_PREFIX ." \
    --bind "alt-c:execute:echo {q} | wl-copy" \
    --ansi --phony
}

# doc:function:fzd:shell:Change directory with fzf.
function fzd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# doc:function:fzg:shell:Search for a string in files with fzf.
function fzg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  local quoted1=$(printf "%q" "$1")
  rg --files-with-matches --no-messages "$1" | fzf --preview "fd-preview -r -p $quoted1 '{}'"
}

# doc:function:fz:shell:Search for a file with fzf and open it in vim.
function fz() {
    local F
    F="$(fd | fzf --preview "fd-preview {}")"
    if [ -n "$F" ]; then
        vim "$F"
    else
        echo "No file selected"
    fi
}

# Hidden helper function to check dependencies
__check_dependencies() {
  if ! command -v docker &> /dev/null; then
    echo '[!] Docker is not installed.'
    return 1
  fi

  if ! command -v fzf &> /dev/null; then
    echo '[!] Fzf is not installed.'
    return 1
  fi
}

# Hidden helper function to select a container
__select_container() {
  local preview='sh -c "docker exec $(echo {} | awk '\''{print $1}'\'') ps aux"'
  while true; do
    case $1 in
      -q) 
        preview='sh -c "docker logs -f $(echo {} | awk '\''{print $1}'\'')"'
        ;;
      *) 
        break
        ;;
    esac
    shift
  done

  local cid
  cid=$(docker ps --format '{{.ID}} {{.Image}} {{.Names}} {{.Status}}' \
    | fzf --preview "$preview" -q "$1" | awk '{print $1}')
  
  if [ -z "$cid" ]; then
    echo '[!] No container selected.'
    return 1
  fi

  echo "$cid"
}

# doc:function:di:docker:Exec into a running container with fzf.
di() {
  __check_dependencies || return

  local cid
  cid=$(__select_container "$1") || return

  local shells=("/bin/bash" "/bin/sh")

  for shell in "${shells[@]}"; do
    echo "[*] Attempting to exec into container with $shell..."
    if docker exec -it --detach-keys='ctrl-z,ctrl-z' "$cid" "$shell"; then
      echo "[+] Successfully exec'd into container with $shell."
      return
    fi
  done

  echo '[!] Failed to exec into the container with available shells.'
}

# doc:function:da:docker:Attach to a running container with fzf.
da() {
  __check_dependencies || return

  local cid
  cid=$(__select_container "$1") || return

  echo "[*] Attempting to attach to container $cid..."
  if docker attach --detach-keys='ctrl-z,ctrl-z' "$cid"; then
    echo "[+] Successfully attached to container $cid."
  else
    echo '[!] Failed to attach to the container.'
  fi
}

# doc:function:dlog:docker:Show logs of a running container with fzf.
dlog() {
  __check_dependencies || return

  local cid
  cid=$(__select_container -q "$1") || return

  docker logs -f "$cid"
}


# doc:zbinding:Ctrl-H:zsh:Show fzf-man widget.
if [[ -n $ZSH_VERSION ]]; then
  # `Ctrl-H` keybinding to launch the widget (this widget works only on zsh, don't know how to do it on bash and fish (additionaly pressing`ctrl-backspace` will trigger the widget to be executed too because both share the same keycode)
  bindkey '^h' fzf-man
  zle -N fzf-man
fi
