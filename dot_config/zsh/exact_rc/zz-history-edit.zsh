hist_delete_fzf() {
  local +h HISTORY_IGNORE=
  local -a ignore
  fc -pa "$HISTFILE"
  if type bat >/dev/null 2>&1; then
    selection=$(fc -rt '%Y-%m-%d %H:%M' -l 1  |
      awk '{ cmd=$0; if (!seen[cmd]++) print $0}' |
      bat --color=always --plain --language sh |
      fzf --bind 'enter:become:echo {+f1}' --header='Press enter to remove; escape to exit' --height=100% --preview-window 'hidden:down:border-top:wrap:<70(hidden)' --prompt='Global History > ' --with-nth=2.. --ansi --preview 'bat --color=always --plain --language sh <<< {2..}' )
    else
      selection=$(fc -rt '%Y-%m-%d %H:%M' -l 1  |
      awk '{ cmd=$0; if (!seen[cmd]++) print $0}' |
      fzf --bind 'enter:become:echo {+f1}' --header='Press enter to remove; escape to exit' --height=100% --preview-window 'hidden:down:border-top:wrap:<70(hidden)' --prompt='Global History > ' --with-nth=2.. )
    fi

  if [ -n "$selection" ]; then
    while IFS= read -r line; do ignore+=("${(b)history[$line]}"); done < "$selection"
    HISTORY_IGNORE="(${(j:|:)ignore})"
    # Write history excluding lines that match `$HISTORY_IGNORE` and read new history.
    fc -W && fc -p "$HISTFILE"
  fi
}

autoload hist_delete_fzf
zle -N hist_delete_fzf

# doc:zbinding:Alt-R:zsh:Delete history entries with fzf.
bindkey ${FZF_HIST_DELETE_BINDKEY:-'^[R'} hist_delete_fzf
bindkey ${FZF_HIST_DELETE_BINDKEY:-'^[r'} hist_delete_fzf