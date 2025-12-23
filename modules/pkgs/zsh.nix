{ pkgs, ... }:

let
  co = "--color=always --icons=always";
  OMZH = "ohmyzsh/ohmyzsh path:plugins";
in
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      btw = "echo I use nix btw";
      svim = "sudo -e";
      update = "nh os switch $HOME/nixos-dotfiles/";

      la = "eza -la ${co}";
      ldot = "eza -ld .* ${co}";
      lD = "eza -lD ${co}";
      lDD = "eza -laD ${co}";
      ll = "eza -l ${co}";
      ls = "eza ${co}";
      lsd = "eza -d ${co}";
      lsdl = "eza -dl ${co}";
      lS = "eza -l -ssize ${co}";
      lT = "eza -l -snewest ${co}";
    };

    initContent = /* shell */ ''
      if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" == 1 ]]; then
         exec Hyprland
      fi

      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

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

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      append = true;
      share = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      findNoDups = true;

      path = "$HOME/.zsh_history";
      ignorePatterns = [ "sudo *" ];
    };

    antidote = {
      enable = true;
      plugins = [
        ''
          zsh-users/zsh-autosuggestions
          zsh-users/zsh-completions
          romkatv/powerlevel10k
          Aloxaf/fzf-tab

          ${OMZH}/git/git.plugin.zsh
          ${OMZH}/sudo/sudo.plugin.zsh
          ${OMZH}/rust/rust.plugin.zsh
          ${OMZH}/foot/foot.plugin.zsh
          ${OMZH}/command-not-found/command-not-found.plugin.zsh
        ''
      ];
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          tag = "master";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];
  };
}
