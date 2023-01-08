#!/bin/sh

##########################################################################
#  Filename:   .../dotfiles/alias.sh                                     #
#  Purpose:    File that defines the aliases for some commands           #
#  Authors:    Giulio Coa <34110430+giulioc008@users.noreply.github.com> #
#  License:    This file is licensed under the LGPLv3.                   #
##########################################################################

alias cd..='cd ..'
alias hystory='history'
alias ls='ls --almost-all --human-readable --color=auto'

if command -v diff > /dev/null 2> /dev/null; then
  alias diff='diff --color=auto'
fi

if command -v grep > /dev/null 2> /dev/null; then
  alias grep='grep --extended-regexp --no-messages --color=auto'
fi

if command -v ip > /dev/null 2> /dev/null; then
  alias ip='ip --color=auto'
fi

if command -v sed > /dev/null 2> /dev/null; then
  alias sed='sed --regexp-extended'
fi

if command -v shellcheck > /dev/null 2> /dev/null; then
  alias shellcheck='shellcheck --check-sourced --color=auto --external-sources'
fi

if command -v shfmt > /dev/null 2> /dev/null; then
  alias shfmt='shfmt --indent 2 --case-indent --binary-next-line --space-redirects'
fi

if command -v sudo > /dev/null 2> /dev/null; then
  alias sudo='sudo '
fi
