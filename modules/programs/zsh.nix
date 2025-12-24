{ pkgs, ... }:

let
  co = "--color=always --icons=always";
  # OMZH = "ohmyzsh/ohmyzsh path:plugins";
in
{
  hjem.users.matercan.rum.programs.zsh = {
    enable = true;

    initConfig = /* shell */ ''

      if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" == 1 ]]; then
         exec Hyprland
      fi

      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      alias btw = "echo I use nix btw";
      alias svim = "sudo -e";
      alias update = "nh os switch $HOME/nixos-dotfiles/";
      alias la = "eza -la ${co}";
      alias ldot = "eza -ld .* ${co}";
      alias lD = "eza -lD ${co}";
      alias lDD = "eza -laD ${co}";
      alias  ll = "eza -l ${co}";
      alias ls = "eza ${co}";
      alias lsd = "eza -d ${co}";
      alias lsdl = "eza -dl ${co}";
      alias lS = "eza -l -ssize ${co}";
      alias lT = "eza -l -snewest ${co}";

      HISTSIZE=1000
      HISTFILE=~/.zsh_history
      SAVEHIST=$HISTSIZE
      HISTDUP=erase
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_dups
      setopt hist_find_no_dups
      setopt his_save_no_dups

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls ${co} $realpath'

      autoload -Uz compinit && compinit

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"

      export PATH="$PATH:$HOME/.local/bin"

    '';


    plugins = {
      "zsh-syntax-highlighting".source = pkgs.zsh-syntax-highlighting;
      "zsh-autocompletions".source = pkgs.zsh-completions;
      "zsh-nix-completions".source = pkgs.nix-zsh-completions;
      "zsh-completions".source = pkgs.zsh-completion-sync;
      "zsh-powerlevel10k".source = pkgs.zsh-powerlevel10k;
      "fzf-tab".source = pkgs.zsh-fzf-tab; 
    };
  };
}
