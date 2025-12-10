{ config, pkgs, zen-browser, ... }:

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
        spotify
    ]; 

    imports = [
        ./pkgs/zsh.nix
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
}
