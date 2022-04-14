#!/usr/bin/env bash

# Increase bash history size
HISTSIZE=500000
HISTFILESIZE=1000000

# shellcheck source=/dev/null
# Load rbenv
eval "$(rbenv init -)"

# shellcheck source=/dev/null
# Load paths
source "${HOME}/.paths"

# shellcheck source=/dev/null
# Load .extra for sensitive information
source "${HOME}/.extra"

# shellcheck source=/dev/null
# Load aliases
source "${HOME}/.aliases"

# shellcheck source=/dev/null
# Load functions
source "${HOME}/.functions"

# shellcheck source=/dev/null
# Load prompt/theme
source "${HOME}/.bash_prompt"
