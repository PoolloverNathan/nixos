inputs:
{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    inputs.disko.nixosModules.disko
  ];
  networking.hostName = "nathanpc";
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Temporary until Hyprland work
  #services.xserver.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  programs.hyprland.enable = true;
  programs.steam.enable = true;
  fileSystems."/".fsType = "tmpfs";
  disko.devices = import ./disks.nix;
  system.stateVersion = "25.05";

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
