{ pkgs, lib, ... }: {
  config = {
    users.users.nginx-sso = {
      uid = 713;
      group = "nogroup";
      isSystemUser = true;
    };
    systemd.services.nginx-sso = {
      description = "Nginx SSO Backend";
      after = [ "network.target" ];
      before = [ "nginx.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.nginx-sso}/bin/nginx-sso \
          --config /nix/persist/nginx-sso/config.yml \
          --frontend-dir /nix/persist/nginx-sso/frontend/
        '';
        Restart = "always";
        User = "nginx-sso";
        DynamicUser = true;
      };
    };
    systemd.tmpfiles.settings.nginx-sso = {
      "/nix/persist/nginx-sso".z = {
        mode = "6500";
        user = "nginx-sso";
        group = "nogroup";
      };
      "/nix/persist/nginx-sso/config.yml".z = {
        mode = "0400";
        user = "nginx-sso";
        group = "nogroup";
      };
    };
    services.nginx.virtualHosts."login.pool.net.eu.org" = {
      addSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          root = "/srv/sso/";
          extraConfig = /*nginx*/ ''
            auth_request /auth;
          '';
        };
        "@login".return = "302 https://login.pool.net.eu.org/login?go=$scheme://$http_host$request_uri";
        "/login".proxyPass = http://127.0.0.1:8082/login;
        "/logout".proxyPass = http://127.0.0.1:8082/logout;
        "/auth" = {
          proxyPass = http://127.0.0.1:8082/auth;
          extraConfig = /*nginx*/ ''
            internal;
          '';
        };
      };
      extraConfig = /*nginx*/ ''
        error_page 401 = @login;
      '';
    };
  };
}
