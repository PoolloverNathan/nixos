{ config, ... }: {
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/nix/persist/cache-priv-key.pem";
  };
  services.nginx.virtualHosts."cache.pool.net.eu.org" = {
    addSSL = true;
    enableACME = true;
    locations."/".proxyPass = let inherit (config.services.nix-serve) bindAddress port; in "http://${bindAddress}:${builtins.toString port}";
  };
}
