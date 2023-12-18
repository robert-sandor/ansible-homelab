EDITOR="vim"

[ ! -f "${HOME}/.zgenom/zgenom.zsh" ] && git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
source "${HOME}/.zgenom/zgenom.zsh"

zgenom autoupdate

if ! zgenom saved; then
  zgenom ohmyzsh
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions
  zgenom load unixorn/fzf-zsh-plugin
  zgenom load romkatv/powerlevel10k powerlevel10k

  zgenom compile "${HOME}/.zshrc"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
# Use bat instead of cat
if command -v bat &> /dev/null; then
  alias cat="bat"
elif command -v batcat &> /dev/null; then
  alias cat="batcat"
fi

# Use ncdu instead of du
alias du="ncdu"

# exa in place of ls
alias ls="exa"
alias la="exa -la"
alias l="exa -l"
alias tree="exa --tree"
