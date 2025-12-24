{ inputs, pkgs, ... }:
let
  zen = inputs.zen-browser.packages.${pkgs.stdenv.system}.default;
  cursor = pkgs.catppuccin-cursors.macchiatoLavender;
  spicepkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  hjem-rum = inputs.hjem-rum.hjemModules.default;

  dandelion = import ./dandelion.nix inputs;
  inherit (dandelion) recursiveImport;

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

  hjem.extraModules = [ hjem-rum ];
  hjem.users.matercan = {
    user = "matercan";
    directory = "/home/matercan";


    packages = with pkgs; [
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

    files = {
      ".config/hypr".source = ./config/hypr;
      ".config/foot".source = ./config/foot;
      ".config/fuzzel".source = ./config/fuzzel;
      ".config/equibop/themes".source = ./config/equibop/themes;
      ".config/equibop/settings".source = ./config/equibop/settings;
      ".config/Kvantum".source = ./config/Kvantum;
      ".config/fastfetch".source = ./config/fastfetch;
      ".config/assets".source = ./config/assets;
    };

    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      HYPRCURSOR_THEME = "catppuccin-macchiato-lavender-cursors";
      XCURSOR_THEME = "catppuccin-macchiato-lavender-cursors";
      XCURSOR_SIZE = "24";
    };

    rum = {
      misc.gtk = {
        enable = true;
        settings = {
          theme-name = "Adwaita-dark";
        };
      };
    };
  };
}
