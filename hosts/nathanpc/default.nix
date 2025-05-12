inputs:
{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../dns.nix
    ../../upnp.nix
    inputs.disko.nixosModules.disko
    (inputs.self.mkNathan { type = "large"; canSudo = true; })
  ];
  networking.hostName = "nathanpc";
  networking.firewall.allowedTCPPorts = [23112 23113 23115];
  networking.firewall.allowedUDPPorts = [24454 34454 54454];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Temporary until Hyprland work
  services.xserver = {
    enable = false;
    #displayManager.sddm.enable = true;
    #desktopManager.plasma5.enable = true;
    displayManager.lightdm = {
      enable = lib.mkForce false;
      #greeters.gtk.enable = false;
      #greeters.slick.enable = true;
    };
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Users = {
        MinimumUid = 1000;
        MaximumUid = 65535;
        HideUsers = lib.concatStringsSep "," (lib.subtractLists ["nathan" "grace" "momzilla"] (builtins.attrNames config.users.users));
      };
    };
  };
  services.flatpak.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;
  programs.steam.enable = true;
  fileSystems."/".fsType = "tmpfs";
  disko.devices = import ./disks.nix;
  services.kubo = {
    enable = true;
    autoMount = true;
    autoMigrate = true;
    enableGC = true;
  };
  system.stateVersion = "25.05";
    services.postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
      '';
    };

  # Stateful
  fileSystems."/root" = {
    device = "/var/usr/root";
    options = ["bind"];
  };
  systemd.tmpfiles.settings.ssh-keys =
    let
      mkSymlink =
        name:
        {
          "/etc/ssh/ssh_host_${name}_key".L.argument = "/var/ssh/k/host_${name}";
          "/etc/ssh/ssh_host_${name}_key.pub".L.argument = "/var/ssh/host_${name}";
        };
    in
      {
        "/var/ssh".d = {
          mode = "4755";
          user = "root";
        };
        "/var/ssh/k".d = {
          mode = "4700";
          user = "root";
        };
      }
    // mkSymlink "rsa"
    // mkSymlink "ed25519";
}
