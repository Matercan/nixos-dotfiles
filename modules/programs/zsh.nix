{ pkgs, ... }:

let
  co = "--color=always --icons=always";
  OMZH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
in
{
  programs.zsh.enable = true;

  hjem.users.matercan.rum.programs.zsh = {
    enable = true;

    initConfig = /* shell */ ''

      if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" == 1 ]]; then
         exec Hyprland
      fi

      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      alias btw="echo I use nix btw";
      alias svim="sudo -e";
      alias update="nh os switch $HOME/nixos-dotfiles/";
      alias la="eza -la ${co}";
      alias ldot="eza -ld .* ${co}";
      alias lD="eza -lD ${co}";
      alias lDD="eza -laD ${co}";
      alias  ll="eza -l ${co}";
      alias ls="eza ${co}";
      alias lsd="eza -d ${co}";
      alias lsdl="eza -dl ${co}";
      alias lS="eza -l -ssize ${co}";
      alias lT="eza -l -snewest ${co}";

      HISTSIZE=1000
      HISTFILE=~/.zsh_history
      SAVEHIST=$HISTSIZE
      HISTDUP=erase
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_dups
      setopt hist_find_no_dups
      setopt hist_save_no_dups

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
      "fzf-tab".source = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";

      "zsh-nix-completions".completions = [ "${pkgs.nix-zsh-completions}/share/zsh/site-functions" ];
      "zsh-autocompletions".completions = [ "${pkgs.zsh-completions}/share/zsh/site-functions" ];
      "zsh-syntax-highlighting".source =
        "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      "zsh-powerlevel10k".source =
        "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

      "omz-git".source = "${OMZH}/plugins/git/git.plugin.zsh";
      "omz-sudo".source = "${OMZH}/plugins/sudo/sudo.plugin.zsh";
      "omz-rust".source = "${OMZH}/plugins/rust/rust.plugin.zsh";
      "omz-foot".source = "${OMZH}/plugins/foot/foot.plugin.zsh";
      "omz-command-not-found".source = "${OMZH}/plugins/command-not-found/command-not-found.plugin.zsh";
    };
  };
}
