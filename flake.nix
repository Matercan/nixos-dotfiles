{
  description = "Mangowc on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    honkai-railway-grub-theme = {
      url = "github:voidlhf/StarRailGrubThemes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    telescope-cmdline-nvim.url = "github:jonarrien/telescope-cmdline.nvim";
    telescope-cmdline-nvim.flake = false;

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, withSystem, moduleWithSystem, ... }: {
      imports = [
        # Optional: use external flake logic, e.g.
        # inputs.foo.flakeModules.default
      ];
      flake = {
        nixosConfigurations.mangowc-btw = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hjem.nix

            inputs.nvf.nixosModules.default
            inputs.hjem.nixosModules.default
            inputs.honkai-railway-grub-theme.nixosModules.${"x86_64-linux"}.default
            inputs.spicetify-nix.nixosModules.spicetify
          ]
          ++ (let
                inherit (inputs.nixpkgs.lib) filter hasSuffix filesystem;
                recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);
              in recursiveImport ./modules);
        };
      };
      systems = [
        "x86_64-linux"
      ];
      perSystem = { config, pkgs, ... }: {
        # Recommended: move all package definitions here.
        # e.g. (assuming you have a nixpkgs input)
        # packages.foo = pkgs.callPackage ./foo/package.nix { };
        # packages.bar = pkgs.callPackage ./bar/package.nix {
        #   foo = config.packages.foo;
        # };
      };
    });
}
