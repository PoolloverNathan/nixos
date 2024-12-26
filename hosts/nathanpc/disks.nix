# vim: ts=2 sts=2 et
{
  disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        esp = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        nix = {
          size = "1T";
          content = {
            type = "filesystem";
            format = "btrfs";
            mountpoint = "/nix";
            mountOptions = ["noatime"];
          };
        };
        var = {
          size = "64G";
          content = {
            type = "filesystem";
            format = "btrfs";
            mountpoint = "/var";
            mountOptions = ["noatime"];
          };
        };
        swap = {
          size = "64G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
        home = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "btrfs";
            mountpoint = "/home";
            mountOptions = ["noatime"];
          };
        };
      };
    };
  };
}
