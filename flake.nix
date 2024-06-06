{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    absolute.url = path:/etc/nixos;
    absolute.flake = false;
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, absolute, ... }: rec {
    nixosConfigurations = {
      nathanlaptopv = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
	  (arg: import (absolute + /configuration.nix) (arg // {
	    inherit absolute;
	    pkgs = import nixpkgs {
	      inherit system;
	    };
	  }))
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.jdoe = import ./home.nix;

          #   # Optionally, use home-manager.extraSpecialArgs to pass
          #   # arguments to home.nix
          # }
        ];
      };
    };
    packages = builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map (att: {
      ${nixosConfigurations.${att}.pkgs.system}.${att} = nixosConfigurations.${att}.config.system.build;
    }) (builtins.attrNames nixosConfigurations));
  };
}
