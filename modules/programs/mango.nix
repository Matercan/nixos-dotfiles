{ config, ... }:
let
  colors = config.colors;

  mangoColors = builtins.toFile "mangoColors" /* conf */ ''
    bordercolor = ${colors.border + "ff"}
    focuscolor = ${colors.accent + "ff"}
    maximizescreencolor = ${colors.accent + "ff"}
  '';
in
{
  programs.mango.enable = true;
  hjem.users.matercan.files.".config/mango/colors.conf".source = mangoColors;
}
