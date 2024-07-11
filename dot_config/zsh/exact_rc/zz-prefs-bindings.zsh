# Key binding ################################################################
# vi: ft=zsh
#
zmodload zsh/termcap
setopt emacs

if [[ "$TERM" != emacs ]]; then
	[[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs \
		"$terminfo[kdch1]" delete-char
	[[ -z "$terminfo[khome]" ]] || bindkey -M emacs \
		"$terminfo[khome]" beginning-of-line
	[[ -z "$terminfo[kend]"  ]] || bindkey -M emacs \
		"$terminfo[kend]" end-of-line
	[[ -z "$terminfo[kich1]" ]] || bindkey -M emacs \
		"$terminfo[kich1]" overwrite-mode

	[[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd \
		"$terminfo[kdch1]" vi-delete-char
	[[ -z "$terminfo[khome]" ]] || bindkey -M vicmd \
		"$terminfo[khome]" vi-beginning-of-line
	[[ -z "$terminfo[kend]"  ]] || bindkey -M vicmd \
		"$terminfo[kend]"  vi-end-of-line
	[[ -z "$terminfo[kich1]" ]] || bindkey -M vicmd \
		"$terminfo[kich1]" overwrite-mode
	
	[[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins \
		"$terminfo[cuu1]" vi-up-line-or-history
	[[ -z "$terminfo[cuf1]"  ]] || bindkey -M viins \
		"$terminfo[cuf1]" vi-forward-char
	[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins \
		"$terminfo[kcuu1]" vi-up-line-or-history
	[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins \
		"$terminfo[kcud1]" vi-down-line-or-history
	[[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins \
		"$terminfo[kcuf1]" vi-forward-char
	[[ -z "$terminfo[kcub1]" ]] || bindkey -M viins \
		"$terminfo[kcub1]" vi-backward-char
	
	# ncurses fogyatekos
	[[ "$terminfo[kcuu1]" == "^[O"* ]] && bindkey -M viins \
		"${terminfo[kcuu1]/O/[}" vi-up-line-or-history
	[[ "$terminfo[kcud1]" == "^[O"* ]] && bindkey -M viins \
		"${terminfo[kcud1]/O/[}" vi-down-line-or-history
	[[ "$terminfo[kcuf1]" == "^[O"* ]] && bindkey -M viins \
		"${terminfo[kcuf1]/O/[}" vi-forward-char
	[[ "$terminfo[kcub1]" == "^[O"* ]] && bindkey -M viins \
		"${terminfo[kcub1]/O/[}" vi-backward-char
	[[ "$terminfo[khome]" == "^[O"* ]] && bindkey -M viins \
		"${terminfo[khome]/O/[}" beginning-of-line
	[[ "$terminfo[kend]"  == "^[O"* ]] && bindkey -M viins \
		"${terminfo[kend]/O/[}" end-of-line

	[[ "$terminfo[khome]" == "^[O"* ]] && bindkey -M emacs \
		"${terminfo[khome]/O/[}" beginning-of-line
	[[ "$terminfo[kend]"  == "^[O"* ]] && bindkey -M emacs \
		"${terminfo[kend]/O/[}" end-of-line
fi

autoload -U   edit-command-line
nano-command-line () {
  if command -v nvim &>/dev/null; then
	local VISUAL='nvim'
	local EDITOR='nvim'
  fi
  edit-command-line
}

# doc:zbinding:Ctrl-F:zsh:Edit the current command line in neovim.
# Edit the current command line in neovim
zle      -N   nano-command-line
bindkey  "^F" nano-command-line

# doc:zbinding:Ctrl-J:zsh:Push the current command onto a stack.
# Push a command onto a stack allowing you to run another command first
bindkey  "^J" push-line

# Bind <ALT-k> to run-help (like vim's K for man)
# doc:zbinding:Alt-K:zsh:Run help for the current command.
bindkey "^[K" run-help
bindkey "^[k" run-help
