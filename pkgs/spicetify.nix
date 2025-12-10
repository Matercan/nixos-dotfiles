{ pkgs, spicetify-nix, ... }:
let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
    programs.spicetify = {
        enable = true;
        
        enabledExtensions = with spicePkgs.extensions; [
            adblockify
            hidePodcasts
            shuffle
        ];
        
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "macchiato";
    };
}
