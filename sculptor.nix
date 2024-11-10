{ pkgs, lib, config, ... }: {
	options.services.sculptor = {
		enable = lib.mkEnableOption "Sculptor";
		version 
	};
}
