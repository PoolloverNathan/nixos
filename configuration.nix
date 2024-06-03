# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# vim: ft=nix ts=2 sts=2 sw=2 et

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secrets.nix
    ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes" "impure-derivations" "ca-derivations"];
    # substitute = false;
  };
  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_6_9;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "kernel.sysrq" = 1;
  };

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };

  swapDevices = [{ device = "/nix/swap"; }];
  environment.variables.EDITOR = "nvim";

  networking = {
    hostName = "nathanlaptopv"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    wireless = {
      enable = true;
      networks = import ./networks.nix;
    };
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    nameservers = ["2a07:a8c0::ef:ea54" "2a07:a8c1::ef:ea54" "8.8.8.8"];
    firewall.allowedTCPPorts = [2423 2352 31337];
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  services = {
    postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
      '';
    };
    xserver = {
      enable = true;
      desktopManager.plasma5 = {
        enable = true;
      };
    };
    tailscale.enable = true;
    openssh.enable = true;
    openssh.settings = {
      X11Forwarding = true;
    };
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      openFirewall = true;
      package = pkgs.minecraftServers.vanilla-1-20;
    };
  };
  security.rtkit.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };
  users.mutableUsers = false;
  users.users = {
    nathan = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = pkgs.lib.attrValues (import /home/nathan/.config/pkgs.nix { inherit pkgs; });
    };
    sand = {
      uid = 1001;
      group = "sand";
      isSystemUser = true;
      packages = with pkgs; [
        nmap
      ];
      hashedPassword = "";
      home = "/var/sand";
    };
    foko = {
      uid = 1004;
      isNormalUser = true;
      packages = import /home/foko/.config/pkgs.nix { inherit pkgs; };
      initialHashedPassword = "";
    };
    bunny = {
      uid = 1005;
      isNormalUser = true;
    };
  };
  users.groups.sand = {};
  users.groups.bunny = {};
  # {{{ Dedicated !neofetch user for security purposes —PoolloverNathan
  users.groups.neofetch.gid = 337;
  users.users.neofetch = {
    isSystemUser = true;
    uid = 337;
    home = "/var/neofetcher";
    createHome = true;
    shell = pkgs.neofetch + /bin/neofetch;
    group = "neofetch";
    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+FPD+DCISuSH1dtBbdAB5C/WMmuTl7ZouGjQQ0cThc''
    ];
  };
  # }}} Dedicated !neofetch user for security purposes —PoolloverNathan

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
    pkgs.git
    pkgs.screen
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.nix-ld = {
    enable = true;
    libraries = [pkgs.glibc];
  };


  # {{{ nrb = sudo nixos-rebuild
  # }}} nrb = sudo nixos-rebuild

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

