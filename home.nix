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
