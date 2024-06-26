# disable fish greeting
set -U fish_greeting

# PATH
fish_add_path "$HOME/.local/bin"

if status is-interactive
  set -Ux EDITOR nvim
  set -Ux VISUAL nvim
  
  set -g fish_key_bindings fish_vi_key_bindings
  
  # starship prompt
  type -q starship; and starship init fish | source

  # abbreviations
  # safer cp, mv and rm
  abbr cp "cp -iv"
  abbr mv "mv -iv"
  abbr rm "rm -rIv" # remove verbose, recursive and interactive if > 3 files
  
  # docker
  abbr dl "docker logs -f"
  abbr dp "docker ps -a"
  abbr dr "docker restart"

  # docker compose
  abbr dcu "docker compose up -d"
  abbr dcd "docker compose down"
  abbr dcr "docker compose restart"
  abbr dcl "docker compose logs -f"
  abbr dcp "docker compose ps -a"

  # aliases 
  type -q eza; and alias l="eza -la"
  type -q exa; and alias l="exa -la"
  type -q bat; and alias cat="bat -p"
  type -q batcat; and alias cat="batcat -p"

  # docker completion
  type -q docker; and docker completion fish | source
end
