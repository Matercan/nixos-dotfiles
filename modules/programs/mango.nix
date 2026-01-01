{ config, ... }: 
let 
  colors = config.colors;

  mangoColors = builtins.toFile "mangoColors" /* conf */ ''
    borderColor = ${colors.border}
  '';
in
{
  hjem.users.matercan.files = {
    ".config/mango/config.conf".source = ../../config/mango/config.conf;

    ".config/mango/colors.sh".source = mangoColors;
  };
}
