inputs:
assert inputs ? nixpkgs; let
  inherit (inputs.nixpkgs.lib) flip flatten hasSuffix filter filesystem pipe recursiveUpdate foldAttrs;

  # simply import ALL nix files in a directory
  recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);

  # Quick reminder. If anything goes wrong this is rexei's fault, and rexei's fault only

  importModules = flip pipe [
    flatten
    (map (x:
      if builtins.isPath x
      then import x
      else x))
    (map (x:
      if builtins.isFunction x
      then x inputs
      else x))
    (foldAttrs recursiveUpdate {})
  ];
in {
  inherit recursiveImport importModules;
}
