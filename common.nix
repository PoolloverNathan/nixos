{ inputs, config, lib, pkgs, ... }: {
  imports = [
    (inputs.self.mkNathan { large = false; canSudo = true; })
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    ./secrets.nix
    (inputs.self.mkTailnet {
      ssh = false;
      extraFlags = ["--accept-dns=false"];
    })
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes" "impure-derivations" "ca-derivations"];
    # substitute = false;
    keep-outputs = true;
    keep-derivations = true;
    trusted-users = ["root" "@wheel"];
    allow-unsafe-native-code-during-evaluation = true;
  };
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_6_11;
  # boot.crashDump.enable = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "kernel.sysrq" = 1;
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = lib.mkDefault "nodev";
      efiSupport = true;
      catppuccin.enable = true;
    };
  };

  networking = {
    wireless = {
      enable = true;
      networks = import ./networks.nix;
    };
  };

  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = lib.mkForce {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    openssh.enable = true;
    openssh.settings = {
      X11Forwarding = true;
    };
  };
  hardware.pulseaudio.enable = false;
  programs = {
    nix-ld = {
      enable = true;
      libraries = [pkgs.glibc];
    };
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        safe.directory = "*";
      };
    };
  };
}
