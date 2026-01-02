{ config, ...}:

let
  colors = config.colors;
in
{
  hjem.users.matercan.rum.programs.foot = {
    enable = true;

    settings = {
      bell.system = "no";

      main = {
        shell = "/etc/profiles/per-user/matercan/bin/zsh";
        font = "JetBrainsMono Nerd Font Mono:size=9";
        font-italic = "Operator Mono:size=9:style=italic";
      };

      colors = {
        background = colors.background;
        foreground = colors.text;
        selection-background = colors.selection_background;
        alpha = 0.8;

        regular0 = colors.regular0;
        regular1 = colors.regular1;
        regular2 = colors.regular2;
        regular3 = colors.regular3;
        regular4 = colors.regular4;
        regular5 = colors.regular5;
        regular6 = colors.regular6;
        regular7 = colors.regular7;

        bright0 = colors.bright0;
        bright1 = colors.bright1;
        bright2 = colors.bright2;
        bright3 = colors.bright3;
        bright4 = colors.bright4;
        bright5 = colors.bright5;
        bright6 = colors.bright6;
        bright7 = colors.bright7;
      };
    };
  };
}

