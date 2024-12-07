{ ... }: {
  imports = [
    ./binary-cache.nix
    ./webdav.nix
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "figura.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:6665";
      };
      "n.pool.net.eu.org" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:2252";
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "nathan.kulzer+acme@protonmail.com";
  };
}
