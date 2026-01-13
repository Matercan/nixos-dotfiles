{ config, ...}:

let
  colors = config.colors;
in
{
  hjem.users.matercan.rum.programs.ghostty = {
    enable = true;

    settings = {
      # Shell configuration
      command = "/etc/profiles/per-user/matercan/bin/zsh";
      
      # Font configuration
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 9;
      font-style-italic = "Operator Mono";
      
      # Background opacity
      background-opacity = 0.8;
      
      # Disable bell
      shell-integration-features = "no-cursor,no-sudo,no-title";
      
      # Colors
      background = colors.background;
      foreground = colors.text;
      selection-background = colors.selection_background;
      
      # Palette colors (0-15)
      palette = [
        "0=${colors.regular0}"
        "1=${colors.regular1}"
        "2=${colors.regular2}"
        "3=${colors.regular3}"
        "4=${colors.regular4}"
        "5=${colors.regular5}"
        "6=${colors.regular6}"
        "7=${colors.regular7}"
        "8=${colors.bright0}"
        "9=${colors.bright1}"
        "10=${colors.bright2}"
        "11=${colors.bright3}"
        "12=${colors.bright4}"
        "13=${colors.bright5}"
        "14=${colors.bright6}"
        "15=${colors.bright7}"
      ];
    };
  };
}
