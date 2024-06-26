{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fokquote.url = github:fokohetman/fok-quote;
    sadan4.url = github:sadan4/dotfiles;
    # absolute.url = path:/etc/nixos;
    # absolute.flake = false;
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, fokquote, ... }: rec {
    # formatter = builtins.mapAttrs (system: pkgs: pkgs.nixfmt-rfc-style)
    nixosModules = {
      nathan = { pkgs, ... }: {
        users.users.nathan = {
          uid = 1471;
          isNormalUser = true;
          group = "users";
          extraGroups = ["wheel"];
          shell = pkgs.powershell + /bin/pwsh;
          packages = pkgs.lib.attrValues (import ./user/nathan.nix (inputs // { inherit pkgs; }));
        };
      };
    };
    nixosConfigurations = {
      nathanlaptopv = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
	  # (arg: import (absolute + /configuration.nix) (arg // {
	  #   inherit absolute;
	  #   pkgs = import nixpkgs {
	  #     inherit system;
	  #   };
	  # }))
          (import ./configuration.nix inputs)
          nixosModules.nathan
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.jdoe = import ./home.nix;

          #   # Optionally, use home-manager.extraSpecialArgs to pass
          #   # arguments to home.nix
          # }
          (mkTailnet {
            ssh = false;
          })
        ];
      };
    };
    mkTailnet = {
      hostname   ? null,
      ssh        ? true,
      extraFlags ? [],
      container  ? null,
      exitNode   ? true,
      tunnelPort ? 41641,
    }: let
      config = {
        services.tailscale = {
          enable = true;
          port = tunnelPort;
          openFirewall = true;
          extraUpFlags =
            (
              if ssh then
                ["--ssh"]
              else
                []
            ) ++ (
              if exitNode == true then
                ["--advertise-exit-node"]
              else if exitNode == null || exitNode == false then
                []
              else
                ["--exit-node=${exitNode}"]
            ) ++ (
              if hostname != null then
                ["--hostname=${hostname}"]
              else
                []
            ) ++ extraFlags;
          authKeyFile = builtins.toFile "tailscale-auth-key" "tskey-auth-kUMZpfCYXF11CNTRL-D2Rz24arzyQEirrNuLgT1RiCDH4Lw8fz";
        };
      };
    in if container == null then
      config
    else {
      containers.${container} = config;
    };
    packages = builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map (att: {
      ${nixosConfigurations.${att}.pkgs.system}.${att} = nixosConfigurations.${att}.config.system.build;
    }) (builtins.attrNames nixosConfigurations));
  };
}
