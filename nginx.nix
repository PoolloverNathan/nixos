{ ... }: {
  imports = [
    ./binary-cache.nix
    ./webdav.nix
    ./outline.nix
    ./upnp.nix
  ];
  networking.upnp.nginx = {
    description = "Nginx port mapping";
    ports = [80 443];
    ignore = true;
    bindsTo = "nginx.service";
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    upstreams = {
      fossil.servers."localhost:8587" = {
        fail_timeout = "5m";
        max_fails = 6;
      };
      fossil2.servers."localhost:8588" = {
        fail_timeout = "5m";
        max_fails = 6;
      };
    };
    virtualHosts = {
      "figura.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:6665";
          proxyWebsockets = true;
        };
      };
      #"outline.pool.net.eu.org" = {
      #  addSSL = true;
      #  enableACME = true;
      #  locations."/" = {
      #    proxyPass = "http://100.124.64.122:3089";
      #    proxyWebsockets = true;
      #  };
      #};
      "n.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:2252";
      };
      "fossil.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://fossil";
        extraConfig = ''
          proxy_read_timeout 1h;
          client_max_body_size 8G;
        '';
      };
      "ckout.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://fossil2";
          basicAuthFile = ./code.htpasswd;
        };
        extraConfig = ''
          proxy_read_timeout 1h;
        '';
      };
      "docker.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://100.124.64.122:5000";
        extraConfig = ''
          client_max_body_size 8G;
        '';
      };
      "forms.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://100.124.64.122:9771";
        extraConfig = ''
          client_max_body_size 8G;
        '';
      };
      "memos.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://100.124.64.122:5230";
      };
      "code.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = http://localhost:2352;
          proxyWebsockets = true;
          basicAuthFile = ./code.htpasswd;
        };
      };
      "sy.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = http://localhost:2352;
          proxyWebsockets = true;
          basicAuthFile = ./code.htpasswd;
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "nathan.kulzer+acme@protonmail.com";
  };
}
