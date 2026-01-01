{ lib, ... }:
let
  colors =
    let
      inherit (builtins)
        fromJSON
        readFile
        ;
    in
    fromJSON (readFile ./colors.json);

  add_hex =
    let
      inherit (lib)
        mapAttrs
        mergeDeepRight
        ;
    in
    attrset: mergeDeepRight attrset (mapAttrs (name: value: { hex = "#" + value; }) attrset);
in
{
  inherit add_hex;

  options.colors =
    with lib;
    mkOption {
      type = types.attrs;
      default = (colors);
      example = literalExpression /* nix */ ''
              {
          background = "24273a";
          foreground ="cad3f5";
          text = "cad3f5";
          border = "181926";
          accent = "c6a0f6";
          secondary = "939ab7";
          secondary_text = "181926";
          selection = "939ab7";
          selection_background = "939ab7";

          regular0 = "181926";
          regular1 = "ee99a0";
          regular2 = "a6da95";
          regular3 = "f5a97f";
          regular4 = "c6a0f6";
          regular5 = "b7bdf8";
          regular6 = "8bd5ca";
          regular7 = "939ab7";

          bright0 = "b8c0e0";
          bright1 = "ed8796";
          bright2 = "a6da95";
          bright3 = "eed49f";
          bright4 = "8aadf4";
          bright5 = "c6a0f6";
          bright6 = "b7bdf8";
          bright7 =  "f4dbd6"

        }
      '';

      description = ''
        An attribute setcontaining the active colors of the system;
        follows iterm colors with a few extras.
        You may use the add_hex function if a program is asking for a value 
        with a # in front.
      '';
    };
}
