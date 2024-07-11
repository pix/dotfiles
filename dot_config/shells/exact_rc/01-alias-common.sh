#
# Some usefull aliases
# vi:ft=bash:
#

typeset -ga YSU_IGNORED_ALIASES
typeset -ga YSU_IGNORED_GLOBAL_ALIASES
export YSU_IGNORED_GLOBAL_ALIASES YSU_IGNORED_ALIASES

galias() {
	if [ -n "$ZSH_VERSION" ] && type zstyle >/dev/null 2>&1; then
		alias -g "$@"
	elif [ -x "$BASH" ] && shopt -q >/dev/null 2>&1; then
		alias "$@"
	fi
}

ialias() {
	alias "$@"
	_ignore "$@"
}

igalias() {
	galias "$@"
	_ignore "$@"
}

_ignore() {
	alias_name="${*}"
	alias_name="${alias_name/=*/}"

	if [ "${#YSU_IGNORED_ALIASES[@]}" -eq 0 ]; then
		YSU_IGNORED_ALIASES=("${alias_name}")
		YSU_IGNORED_GLOBAL_ALIASES=("${alias_name}")
	else
		YSU_IGNORED_ALIASES+=("${alias_name}")
		YSU_IGNORED_GLOBAL_ALIASES+=("${alias_name}")
	fi
}


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors -a -f ~/.dir_colors ]; then
	eval "$(dircolors -b ~/.dir_colors)"
fi

# no spelling correction on mv/cp/mkdir
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias du='du -kh'
alias rdesktop="rdesktop -r sound:local -r disk:linux=/ -r disk:home=$HOME -x l -K -f -P -a 24"

igalias grep='grep --color=auto'
igalias fgrep='fgrep --color=auto'
igalias egrep='egrep --color=auto'

ialias :wq='exit'
ialias ..='cd ..'
ialias cd..="cd .."

# The 'ls' family (this assumes you use the GNU ls) ##########################
alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -Al'         # show hidden files

if command -v eza &>/dev/null; then
	eza_params=('--git' '--icons=always' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')
	alias ls='eza ${eza_params}'
	alias l='eza --git-ignore ${eza_params}'
	alias ll='eza --all --header --long ${eza_params}'
	alias llm='eza --all --header --long --sort=modified ${eza_params}'
	alias la='eza -lbhHigUmuSa ${eza_params}'
	alias lx='eza -lbhHigUmuSa@ ${eza_params} --sort=extension'
	alias lt='eza --tree ${eza_params}'
	alias tree='eza --tree ${eza_params}'
fi

if command -v nvim &>/dev/null; then
	igalias vim='nvim'
	igalias vi='nvim'
elif command -v vim &>/dev/null; then
	igalias vi='vim'
fi

# spelling typos - highly personnal :-) ######################################
#
ialias xs='cd'
ialias vf='cd'
ialias more='less'
ialias moer='less'
ialias moew='less'
ialias kk='ll'
ialias ks='ls'