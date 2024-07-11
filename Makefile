.PHONY: default
default:
	chezmoi init
	chezmoi apply
	dotfiles-doc --update-cache

.PHONY: README.md
README.md:
	chezmoi execute-template < README.md.tmpl | tee README.md > /dev/null

.PHONY: build
build: default check README.md

.PHONY: check
check: $(patsubst %.sh.tmpl,%.tmpl.check,$(wildcard .chezmoiscripts/*.sh.tmpl))
	echo "All files passed shellcheck"

.PHONY: .chezmoiscripts/%.tmpl.check
.chezmoiscripts/%.tmpl.check: .chezmoiscripts/%.sh.tmpl
	chezmoi execute-template < $< | shellcheck -