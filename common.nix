{ inputs, config, lib, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.age
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

  # boot.kernelPackages = pkgs.linuxPackages_6_11;
  # boot.crashDump.enable = true;

  boot.kernelParams = [
    "softlockup_panic=1"
    "nmi_watchdog=panic"
  ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "kernel.sysrq" = 1;
    "kernel.panic" = 5;
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

  environment.systemPackages = [
    pkgs.ecryptfs
  ];
  security.wrappers = {
    "mount.ecryptfs_private" = {
      owner = "root";
      group = "root";
      setuid = true;
      source = "${pkgs.ecryptfs}/bin/mount.ecryptfs_private";
    };
  };

  networking = {
    wireless = {
      enable = true;
      networks = import ./networks.nix;
    };
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [22 2377 7946 4789];
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

  fonts.packages = builtins.filter (lib.attrsets.isDerivation) (builtins.attrValues pkgs.nerd-fonts);

  services = {
    pulseaudio.enable = false;
    openssh.enable = true;
    openssh.settings = {
      X11Forwarding = true;
    };
  };
  virtualisation = {
    docker = {
      enable = true;
      liveRestore = false; # incompatible with swarm
    };
  };
  users.groups.docker = {
    members = ["nathan"];
  };
  users.users = {
    voxel = {
      uid = 1069;
      hashedPassword = "$y$j9T$rs5rZ4Hbbo2xJvdAsIqEu0$qpdybpvf2l5u7qro2ND77D4v6Zbb062JcndqsCqGFG3";
      isNormalUser = true;
      group = "users";
      extraGroups = ["docker"];
    };
    momzilla = {
      uid = 1365;
      isNormalUser = true;
      createHome = true;
      group = "users";
      packages = [
        pkgs.firefox
        pkgs.kitty
      ];
    };
    grace = {
      uid = 1500;
      isNormalUser = true;
      createHome = true;
      group = "users";
      hashedPassword = "$y$j9T$K8M1g/BDdjUkkdjwGjwN80$RURlskVc3WEbqqMmow2cRKr492qnnRPxBXv64QOuo17";
      packages = [
        pkgs.firefox
      ];
    };
    foko = {
      uid = 1004;
      isNormalUser = true;
      # packages = import /home/foko/.config/pkgs.nix { inherit pkgs; };
      initialHashedPassword = "";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgTxm0wBvRg8YSezwHvRYOhKT7G8lv5JtrlGNp5gkg7 foko@fokolaptop"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAING43cVUOV9hmvkQNOKnYKcaBzamSFRnLGcLb0JlDlOZ paprykkania@gmail.com"
      ];
    };
  };
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

  home-manager.backupFileExtension = "~PRE-HOME-MANAGER~";
}
