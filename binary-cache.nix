{ config, ... }: {
	services.nix-serve = {
		enable = true;
		secretKeyFile = "/nix/persist/cache-priv-key.pem";
	};
	services.nginx.virtualHosts."cache.nix.pool.net.eu.org" = {
		enableACME = true;
		locations."/".proxyPass = let inherit (config.services.nix-serve) bindAddress port; in "http://${bindAddress}:${builtins.toString port}";
	};
}
