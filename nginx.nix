{ pkgs, ... }: {
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
    services = ["nginx.service"];
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
      "chromebook.ccpsnet.net" = {
        locations."/".root = pkgs.linkFarm "chromebook.ccpsnet.net" (let
          pac = /*js*/ ''
            function FindProxyForURL(url, host) {
              // TODO: look into proxying in some cases
              if (isInNet(myIpAddress(), "192.168.243.0", "255.255.255.0")) {
                if (isPlainHostName(host) ||
                  shExpMatch(host, "*.local") ||
                  shExpMatch(host, "*.na") ||
                  dnsDomainIs(host, "chromebook.ccpsnet.net") ||
                  isInNet(dnsResolve(host), "10.0.0.0", "255.0.0.0") ||
                  isInNet(dnsResolve(host), "172.16.0.0",  "255.240.0.0") ||
                  isInNet(dnsResolve(host), "192.168.0.0",  "255.255.0.0") ||
                  isInNet(dnsResolve(host), "127.0.0.0", "255.255.255.0"))
                  return "DIRECT";
                return "SOCKS5 192.168.243.60:1080";
              } else return "DIRECT";
            }
          '';
        in {
          "homeaccessnew.pac" = builtins.toFile "homeaccessnew.pac" pac;
          "hsaccessnew.pac" = builtins.toFile "homeaccessnew.pac" pac;
          "homeaccesshs.pac" = builtins.toFile "homeaccessnew.pac" pac;
        });
      };
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
      "dolist.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = http://100.124.64.122:7368;
          proxyWebsockets = true;
        };
      };
      "eizel.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = http://100.124.64.122:1420;
          proxyWebsockets = true;
          extraConfig = ''
            if ($http_user_agent ~ Fossil) {
              rewrite .+ https://fossil.pool.net.eu.org/eazs;
            }
          '';
        };
      };
      "poolside.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = http://127.0.0.1:9709;
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "nathan.kulzer+acme@protonmail.com";
  };
}
