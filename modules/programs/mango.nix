{ config, ... }:
let
  colors = config.colors;

  mangoColors = builtins.toFile "mangoColors" /* conf */ ''
    borderColor = ${colors.border}
    focusColor = ${colors.accent}
    maximizescreenColor = ${colors.accent}
  '';
in
{
  programs.mango.enable = true;

  hjem.users.matercan.files = {
    ".config/mango/config.conf".source = ../../config/mango/config.conf;

    ".config/mango/colors.sh".source = mangoColors;
  };
}
