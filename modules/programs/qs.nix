{ config, pkgs, ... }:
let
  colorsFile = builtins.toFile "qsc-colors.json" (builtins.toJSON config.colors-hex);

  script = pkgs.writeShellScript "write-quickshell-colors" ''
    cp ${colorsFile} /home/matercan/nixos-dotfiles/config/quickshell/Data/colors.json
  '';
in
{
  systemd.user.services.writeQuickshellColors = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Fills out colors for quickshell";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${script}";
      RemainAfterExit = true;
    };
  };
}
