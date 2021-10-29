export PATH=$HOME/.bin:$PATH:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/sbin:$HOME


HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

plugins=(asdf autojump alias-finder cp docker direnv history git gnu-utils vi-mode command-not-found)

eval "$(starship init zsh)"

# hook into direnv
eval "$(direnv hook zsh)"

# load local zshrc if there is one
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi