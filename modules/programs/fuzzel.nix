{ config, ... }:

let
  colors = config.colors;
in
{

  hjem.users.matercan.rum.programs.fuzzel = {
    enable = true;

    settings = {
      border.radius = 10;
      border.width = 4;
      demu.exit-immediate-if-empty = "yes";

      main = {
        font = "Fira Code:size=9";
        placeholder = ">w<";
        prompt = "❯ ";
        inner-pad = 10;
        tabs = 2;
        lines = 10;
        dpi-aware = "yes";
        icons-enabled = false;
        horizontal-pad = 14;
        width = 60;
        image-size-ratio = 1;
        terminal = "foot";
      };

      colors = {
        background = colors.background;
        text = colors.text;
        border = colors.border;
        prompt = colors.accent;
        input = colors.accent;

        selection = colors.secondary;
        selected-text = colors.secondary_text;
        selection_match = colors.accent;
        counter = colors.accent;
      };
    };
  };
}
