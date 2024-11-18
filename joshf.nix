{ config, pkgs, ... }: {
  users.users.joshf = {
    uid = 1989;
    group = "users";
    createHome = false;
    isNormalUser = true;
  };
  systemd.tmpfiles.settings."joshf-dirs" = {
    "${config.users.users.joshf.home}/.ssh/authorized_keys".f = {
      user = "joshf";
      group = config.users.users.joshf.group;
      mode = "0400";
      argument = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANBLUSHY3deNr5aUsZPlKjE47kgb08tFgqlhR8q7SET joshf@Joshs-PC
      '';
    };
  };
}
