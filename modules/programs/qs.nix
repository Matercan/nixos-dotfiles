{
  systemd.user.services.writeQuickshellColors = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Fills out colors for quickshell";
    serviceConfig = {
      Type = "simple";
      ExecStart = builtins.toFile "qsc" ''
        #! /bin/sh
          cp /home/matercan/nixos-dotfiles/parts/colors.json /home/matercan/nixos-dotfiles/config/quickshell/Data/colors.json
      '';
    };
  };
}
