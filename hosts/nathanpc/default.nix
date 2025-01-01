inputs:
{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    inputs.disko.nixosModules.disko
  ];
  networking.hostName = "nathanpc";
  # Temporary until Hyprland work
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.hyprland.enable = true;
  fileSystems."/".fsType = "tmpfs";
  disko.devices = import ./disks.nix;
  system.stateVersion = "25.05";

  # Stateful
  
}
