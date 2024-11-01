{ config, pkgs, ... }: {
  users.users.ci = {
    uid = 172;
    group = "ci";
    home = "/run/ci";
    createHome = false;
    isSystemUser = true;
    shell = pkgs.bash;
  };
  users.groups.ci = {};
  systemd.tmpfiles.settings."ci-dirs" = {
    "${config.users.users.ci.home}".D = {
      user = "ci";
      group = config.users.users.ci.group;
      mode = "0500";
    };
    "${config.users.users.ci.home}/.ssh" = {
      d = {
        user = "ci";
        group = config.users.users.ci.group;
        mode = "0500";
      };
      X = {};
    };
    "${config.users.users.ci.home}/.ssh/authorized_keys".f = {
      user = "ci";
      group = config.users.users.ci.group;
      mode = "0400";
      argument = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK+Y5/wuVKSd5oyL5tKWEN6N1KnrGBavZuu3zP6hsyxU runner@github-actions
      '';
    };
  };
}
