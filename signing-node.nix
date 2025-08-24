{...}: {
  services.tailscale.enable = true;
  services.openssh.enable = true;
  users.users.root.password = "nixos";
  users.mutableUsers = false;
  fileSystems = {
    "/".type = "tmpfs";
    "/var/lib/tailscale" = { type = "ext4"; device = /dev/disk/by-label/nixos; };
  };
}
