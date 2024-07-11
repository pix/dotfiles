# vim:ft=zsh:

autoload -Uz history-beginning-search-menu-space-end history-beginning-search-menu
zle -N history-beginning-search-menu-space-end history-beginning-search-menu

# doc:zbinding:Typing+Up-Arrow:zsh:Begin typing a command and press the Up Arrow key to search through your command history.
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# doc:zbinding:Typing+Down-Arrow:zsh:Begin typing a command and press the Down Arrow key to search through your command history backward.
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi
