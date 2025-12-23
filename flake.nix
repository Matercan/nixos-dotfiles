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

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    telescope-cmdline-nvim.url = "github:jonarrien/telescope-cmdline.nvim";
    telescope-cmdline-nvim.flake = false;

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      dandelion = import ./dandelion.nix inputs;
      inherit (dandelion) recursiveImport;
      system = "x86_64-linux";
    in
    {

      nixosConfigurations.mangowc-btw = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nvf.nixosModules.default
          inputs.spicetify-nix.homeManagerModules.spicetify
          inputs.hjem.nixosModules.default
          inputs.honkai-railway-grub-theme.nixosModules.${system}.default
        ]
        ++ (recursiveImport ./modules);

      };
    };
}
