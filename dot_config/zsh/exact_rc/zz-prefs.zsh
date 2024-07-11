# Misc tweaks #########################################################
# vi: ft=zsh
#

# I like all my history files in ~/.history
if [[ ! -d ~/.history ]]; then
    mkdir ~/.history
fi
# Keep almost everything 
export HISTSIZE=1000000
export HISTFILE=~/.history/zsh
export SAVEHIST=1000000

# Misc options
setopt \
  auto_cd \
  autopushd \
  pushd_ignore_dups \
  correct \
  extended_glob \
  interactive_comments \
  no_bg_nice \
  no_hup \
  print_eight_bit


# History options
setopt  \
  inc_append_history \
  hist_ignore_all_dups \
  hist_reduce_blanks \
  hist_verify \
  hist_expire_dups_first \
  hist_find_no_dups \
  hist_ignore_space \
  extended_history \
  share_history
 
# why do I need this ?
fc -R

# automatically quotes metacharacter while typing a url
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# wait 10 seconds before querying for a rm which contains a *
setopt rmstarwait

if (( $+commands[dircolors] )) ; then
  # GNU Colors
  [ -f ~/.dir_colors ] && eval $(dircolors -b ~/.dir_colors)
  export ZLSCOLORS="${LS_COLORS}"
  zmodload  zsh/complist
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# completion menu ############################################################
# vi: ft=zsh
# 

zstyle ':completion:*' menu select=1

# Completion options #########################################################
#
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:::::' completer _complete _approximate
zstyle -e ':completion:*:approximate:::' max-errors \
'reply=( $(( ($#PREFIX+$#SUFFIX)/4 )) numeric )'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'
# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"
# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# tag-order 'globbed-files directories' all-files 
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'
# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

