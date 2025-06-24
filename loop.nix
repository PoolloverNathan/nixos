{ config, lib, ... }: {
  options.environment.loopDevices = lib.mkOption {
    description = ''
      The list of loop devices to initialize on boot.
    '';
  };
}
