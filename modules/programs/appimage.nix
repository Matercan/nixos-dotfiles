{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    fuse
    icu
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

}
