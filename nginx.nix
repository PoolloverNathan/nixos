{ ... }: {
	imports = [
		./binary-cache.nix
	];
	services.nginx = {
		enable = true;
		recommendedProxySettings = true;
		recommendedTlsSettings = true;
	};
	security.acme = {
		acceptTerms = true;
		defaults.email = "nathan.kulzer+acme@protonmail.com";
	};
}
