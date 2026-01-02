{ config, pkgs, lib }:
let
  writeColorsScript = pkgs.writeShellScript {
    name = "copy nix files";
    text = /* shell */ ''
      #! ${pkgs.runTimeShell}
      mkdir -p /home/matercan/nixos-dotfiles/config/quickshell/Data
      cp /home/matercan/nixos-dotfiles/parts/colors.json /home/matercan/nixos-dotfiles/config/quickshell/Data/colors.json
      EOF
    '';

    executabale = true;
  };
in
{
  system.activationScripts.writeQuickshellColors = ''
    ${writeColorsScript}
  '';
}
