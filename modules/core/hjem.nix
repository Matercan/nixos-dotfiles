{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  zen = inputs.zen-browser.packages.${pkgs.stdenv.system}.default;
  qs = inputs.quickshell.packages.${pkgs.stdenv.system}.default;

  cursor = pkgs.catppuccin-cursors.macchiatoLavender;
  gtk-theme = pkgs.gnome-themes-extra;

  hjem-rum = inputs.hjem-rum.hjemModules.default;
  hjem-impure = inputs.hjem-impure.hjemModules.default;

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

  hjem.extraModules = [
    hjem-rum
    hjem-impure
  ];
  hjem.users.matercan = {
    user = "matercan";
    directory = "/home/matercan";

    packages = with pkgs; [
      zsh-powerlevel10k
      ripgrep
      fzf
      zoxide

      wl-clipboard
      grim
      slurp
      wayfreeze
      swappy


      zen
      obs-studio
      equibop
      protonvpn-gui
      prismlauncher
      qs

      gtk-theme
      cursor
      ns
      pavucontrol
      fcitx5
      fcitx5-mozc
    ];

    files = {
      ".config/equibop/themes".source = ../../config/equibop/themes;
      ".config/equibop/settings".source = ../../config/equibop/settings;
      ".config/Kvantum".source = ../../config/Kvantum;
      ".config/fastfetch".source = ../../config/fastfetch;
      ".config/assets".source = ../../config/assets;
    };

    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      HYPRCURSOR_THEME = "catppuccin-macchiato-lavender-cursors";
      XCURSOR_THEME = "catppuccin-macchiato-lavender-cursors";
      XCURSOR_SIZE = "24";
      XDG_CURRENT_DESKTOP="wlroots";
      
      QT_QPA_PLATFORM="wayland";
      QT_QPA_PLATFORMTHEME="qt6ct";
      QT_AUTO_SCREEN_SCALE_FACTOR=1;
      QT_ENABLE_HIGHDPI_SCALING=1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION=1;
      SDL_VIDEODRIVER="wayland";
    };

    impure = {
      enable = true;
      dotsDir = "${../../config}";
      dotsDirImpure = "/home/matercan/nixos-dotfiles/config";
    };

    xdg.config.files =
      let
        dots = config.hjem.users.matercan.impure.dotsDir;
      in
      {
        "quickshell".source = dots + "/quickshell";
        "mango/config.conf".source = dots + "/mango/config.conf"; 
      };
  };
}
