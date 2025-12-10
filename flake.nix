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

        
	nvf = {
	    url = "github:notashelf/nvf";
	    inputs = {
		nixpkgs.follows = "nixpkgs";
		home-manager.follows = "home-manager";
	    };
	};
    };

    outputs = { nixpkgs, home-manager, honkai-railway-grub-theme, zen-browser,  nvf, ... }: {
	nixosConfigurations.mangowc-btw = nixpkgs.lib.nixosSystem {
	   system = "x86_64-linux";
	   specialArgs = { inherit honkai-railway-grub-theme; };
	   modules = [
	      ./configuration.nix
	      ./pkgs/neovim.nix
	      nvf.nixosModules.default
	      home-manager.nixosModules.home-manager
	      {
		  home-manager = {
		      useGlobalPkgs = true;
		      useUserPackages = true;
		      users.matercan = import ./home.nix;
		      backupFileExtension = "backup";
		      extraSpecialArgs = { inherit zen-browser; };
		  };
	      }
	    ];
	};
    };
}
