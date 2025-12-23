{
  pkgs,
  inputs,  
  ...
}:
let
  spicetify = 
  zen = inputs.zen-browser.packages.${pkgs.stdenv.system}.default;
  cursor = pkgs.catppuccin-cursors.macchiatoLavender;

  ns = (
    pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      excludeShellChecks = [ "SC2016" ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    }
  );
in
{
  home.username = "matercan";
  home.homeDirectory = "/home/matercan";
  home.stateVersion = "25.11";

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.macchiatoLavender;
    name = "catppuccin-macchiato-lavender-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    zsh-powerlevel10k
    ripgrep
    fzf
    zoxide
    wl-clipboard

    zen
    quickshell
    obs-studio
    equibop
    protonvpn-gui
    prismlauncher

    cursor
    ns
    pavucontrol
    hyprshot
    hyprpicker
    fcitx5
    fcitx5-mozc
  ];


  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/foot".source = ./config/foot;
  home.file.".config/fuzzel".source = ./config/fuzzel;
  home.file.".config/equibop/themes".source = ./config/equibop/themes;
  home.file.".config/equibop/settings".source = ./config/equibop/settings;
  home.file.".config/Kvantum".source = ./config/Kvantum;
  home.file.".config/fastfetch".source = ./config/fastfetch;
  home.file.".config/assets".source = ./config/assets;
}
