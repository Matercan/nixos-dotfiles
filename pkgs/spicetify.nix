{ pkgs, spicetify-nix, ...}:
let
    spicePkgs = inputs.spicetify-nix.legeacyPackages.${pkgs.stdenv.system};
in
{
    programs.spicetify = {
        enable = true;
        enabledExtentions = with spicePkgs.extensions; [
            adblockify
            hidePodcasts
            shuffle
        ];
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "macchiato";
    }
}
