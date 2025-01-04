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
    virtualHosts = {
      "figura.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:6665";
          proxyWebsockets = true;
        };
      };
      "n.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:2252";
      };
      "fossil.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:8587";
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "nathan.kulzer+acme@protonmail.com";
  };
}
