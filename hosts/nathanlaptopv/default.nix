# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# vim: ft=nix ts=2 sts=2 sw=2 et

inputs:
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      (inputs.self.mkNathan { type = "interactive"; canSudo = true; })
      # (builtins.fetchurl https://nathanlaptopv.axolotl-snake.ts.net/tailscale.nix)
      ../../nginx.nix
      ../../dns.nix
      ../../upnp.nix
      ../../sso.nix
      ../../ci.nix
    ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    config.common.default = ["hyprland"];
  };

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  systemd.services.reload-ssh-keys = {
    script = ''
      cp -rT /nix/persist2/ssh/ /etc/ssh/
    '';
    wantedBy = [ "multi-user.target" ];
  };

  swapDevices = [{ device = "/nix/swap"; }];
  environment.variables.EDITOR = "nvim";

  networking = {
    hostName = "nathanlaptopv"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    nameservers = ["8.8.8.8" "8.8.4.4"];
    nftables.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [2423 2352 31337 6697];
      rejectPackets = true;
    };
    # TODO(PoolloverNathan): add adlists
    hosts = {
      "70.16.249.212" = ["chromebook.ccpsnet.net" "h.pool.net.eu.org"];
      #"0.0.0.0" = ["api.hapara.com" "hl.hapara.com"];
      "192.168.136.146" = ["proxy.na"];
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
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
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Users = {
          MinimumUid = 1000;
          MaximumUid = 65535;
          HideUsers = lib.concatStringsSep "," (lib.subtractLists ["nathan" "grace"] (builtins.attrNames config.users.users));
        };
      };
    };
    #desktopManager.plasma6.enable = true;
    flatpak.enable = true;
    fprintd.enable = true;
    minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      openFirewall = true;
      package = pkgs.minecraftServers.vanilla-1-20;
    };
    pipewire.enable = lib.mkForce false;
    pulseaudio.enable = lib.mkForce true;
    rsyncd.enable = true;
    # ircdHybrid = {
    #   enable = true;
    #   serverName = "Poolrc";
    #   description = "IRC server for PoolloverNathan's tailnet.";
    #   extraIPs = ["127.0.0.1"];
    # };
    ngircd.enable = true;
    ngircd.config = ''
      [OPTIONS]
      PAM = false
    '';
    jellyfin.enable = true;
    jellyfin.openFirewall = true;
    hypridle.enable = true;
  };
  security.rtkit.enable = true;
  programs = {
    hyprland.enable = true;
    steam.enable = true;
    hyprlock.enable = true;
  };

  home-manager.users.nathan = {
    wayland.windowManager.hyprland.extraConfig = ''
      monitor = ,preferred,auto,auto
      monitor = eDP-1,disable
      monitor = HDMI-A-1,1280x1024@60hz,0x0,1
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.

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
    root = {
      uid = 0;
      extraGroups = ["wheel"];
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
    bunny = {
      uid = 1005;
      isNormalUser = true;
    };
    win = {
      uid = 26898;
      isSystemUser = true;
      group = "nogroup";
      hashedPassword = "$y$j9T$w4v8ARWrFjmQ9iDRDWsKN1$8xb16K.8qZIZr.5AMWwKOwvgHK9rruBAk7Dm4PQN1o8";
      shell = pkgs.bash;
    };
    kai = {
      uid = 1022;
      isNormalUser = true;
      group = "users";
      extraGroups = ["wheel"];
      hashedPassword = "$y$j9T$rDEo4MR.C4ZzaBPXkpWEb.$FpdzrLaf4E8R.IhyXsdjSYQ6WObpHnQKO50a0mBpKb6";
    };
    proto = {
      uid = 1936;
      isNormalUser = true;
      createHome = true;
      group = "users";
      hashedPassword = "$y$j9T$4XOTYGGwMYkfwfse/QBhS1$GzPbhXZ4oKZbHQ2sn7iVDUN2tEAUx03HdxAfOx/Fey/";
    };
    blahai = {
      uid = 10667;
      isNormalUser = true;
      group = "users";
    };
    zoot = {
      uid = 10699;
      isNormalUser = true;
      group = "users";
    };
    nemmy = {
      uid = 1253;
      isNormalUser = true;
      group = "users";
      hashedPassword = "$y$j9T$laBYp0OM6ZMEg.FeGV4J20$MOSlQJA.XGo4SXsn7zUi5o3Y6SUp5tBhASDoTFMJ6j4";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMh9MzUXUv/qhUUbUE8KMykreeGbwSDQk/YHPcTi0Wc panda@pandaptable.moe"
      ];
    };
    marley = {
      uid = 5812;
      isNormalUser = true;
      group = "users";
      extraGroups = ["wheel"];
      hashedPassword = "$y$j9T$4x9YDrkENEijFKAhbHItJ0$SXqhFvxY0mjuXGilTd0Cn5dCJYQMVOgN07E.zi94fe5";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqKSVKd79mV0yXHI7ZhdG8OsM/6NocyeNGiH7WTLlMi marley@maakuarch"
      ];
    };
    zen = {
      uid = 1079;
      isNormalUser = true;
      group = "users";
      hashedPassword = "$y$j9T$Br08YeOQm97FzgKohA5dL.$3fqhRV0emN29hflWNMZlrNr9f571bt7441rtrPDn1s3";
    };
    null = {
      uid = 1984;
      isNormalUser = true;
      group = "users";
    };
  };
  users.groups.sand = {};
  users.groups.bunny = {};
  users.groups.ci = {};
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
    pkgs.bashInteractive
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.ffmpeg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  # system.copySystemConfiguration = true;

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

  home-manager.users.blahai.home.stateVersion = "23.11";
  home-manager.users.blahai.home.file.".ssh/authorized_keys".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILPbmiNqoyeKXk/VopFm2cFfEnV4cKCFBhbhyYB69Fuu";
}

