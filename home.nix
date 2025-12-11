{ config, pkgs, zen-browser, spicetify-nix, ... }:
let 
    spicetify = spicetify-nix.lib.mkSpicetify pkgs {};
in
{
    home.username = "matercan";
    home.homeDirectory = "/home/matercan";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
    	zsh-powerlevel10k 
        zen-browser.packages.${pkgs.system}.default
        fzf
        zoxide
        obs-studio
        wl-clipboard
        ripgrep
        equibop
        protonvpn-gui
        hyprshot
        hyprpicker

        (pkgs.writeShellApplication {
            name = "ns";
            runtimeInputs = with pkgs; [
            fzf
            nix-search-tv
            ];
            excludeShellChecks = ["SC2016"];
            text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        })
    ]; 

    imports = [
        spicetify-nix.homeManagerModules.spicetify
        ./pkgs/zsh.nix
        ./pkgs/spicetify.nix
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
}
