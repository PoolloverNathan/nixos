{
  pkgs,
  options,
  config,
  ...
}: {
  services.nginx = {
    enable = true;
    virtualHosts."h.pool.net.eu.org" = {
      listen = [
        { addr = "0.0.0.0"; port = 80; }
        { addr = "0.0.0.0"; port = 443; ssl = true; }
        { addr = "[::]"; port = 80; }
        { addr = "[::]"; port = 443; ssl = true; }
      ];
      addSSL = true;
      enableACME = true;
      locations."/pluginsearch/".proxyPass = http://localhost:22942/;
    };
  };
  systemd.services.pluginsearch = {
    upheldBy = ["nginx.service"];
    script = "${pkgs.writers.writeJS "pluginsearch" {
      libraries = [./.]; 
    } ''
      require("/etc/nixos/pluginsearch/index.js")
    ''}";
  };
}
