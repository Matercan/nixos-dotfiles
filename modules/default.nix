{
  lib,
  ...
}:
let
  inherit (lib) filesystem hasSuffix hasPrefix;

  allNixFiles = filesystem.listFilesRecursive ./.;

  filterFile =
    path:
    let
      name = baseNameOf path;
    in
    path != ./default.nix # So as to not reimport this file
    && hasSuffix ".nix" name
    && !hasPrefix "_" name;
in
{
  imports = builtins.filter filterFile allNixFiles;
}
