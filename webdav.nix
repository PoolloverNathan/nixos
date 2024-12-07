{ ... }: {
  services.nginx.virtualHosts = {
    "dav.pool.net.eu.org" = {
      addSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://100.100.100.100:8080";
    };
  };
}
