{ pkgs, lib, config, ... }:
{
  options.networking.upnp = lib.mkOption {
    description = "UPnP mappings for ports to publicly expose.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "this UPnP mapping";
          ports = lib.mkOption {
            description = "The ports to map, as a list of port numbers (TCP will be assumed) or submodules.";
            type = lib.types.listOf (
              lib.types.coercedTo lib.types.number (port: { inherit port; }) (
                lib.types.submodule (
                  { config, ... }:
                  {
                    options = {
                      port = lib.mkOption {
                        description = "The local port number to map.";
                        type = lib.types.port;
                      };
                      publicPort = lib.mkOption {
                        description = "The public port number to map.";
                        type = lib.types.port;
                        default = config.port;
                      };
                      protocol = lib.mkOption {
                        description = "The protocol to map. This is usually TCP, but some services (e.g. VPNs) may require UDP.";
                        type = lib.types.enum [
                          "tcp"
                          "udp"
                        ];
                        default = "tcp";
                      };
                    };
                  }
                )
              )
            );
            default = [ ];
          };
          openFirewall = lib.mkOption {
            description = "Opens these ports in the firewall. This is required for incoming connections to work.";
            type = lib.types.bool;
            default = true;
          };
          ignore = lib.mkOption {
            description = "Whether to ignore a disconnected IGD device.";
            type = lib.types.bool;
            default = false;
          };
          overwrite = lib.mkOption {
            description = "Whether to clobber an existing port mapping by deleting the existing one.";
            type = lib.types.bool;
            default = true;
          };
          description = lib.mkOption {
            description = "The description for this port mapping.";
            type = lib.types.singleLineStr;
          };
          services = lib.mkOption {
            description = "What service(s) should create this UPnP mapping.";
            type = lib.types.listOf lib.types.singleLineStr;
            default = [];
          };
        };
      }
    );
    default = { };
  };
  config = {
    networking.firewall.allowedUDPPorts = [1899]; # multicast
    systemd.services = lib.mapAttrs' (name: value: let
      startCommand = lib.escapeShellArgs (
        [
          "upnpc"
          "-r"
          "-e"
          value.description
        ]
        ++ lib.concatMap (map: [
          map.port
          map.publicPort
          (lib.toUpper map.protocol)
        ]) value.ports
      );
      stopCommand = lib.escapeShellArgs (
        [
          "upnpc"
          "-f"
        ]
        ++ lib.concatMap (map: [
          map.publicPort
          (lib.toUpper map.protocol)
        ]) value.ports
      );
    in {
      name = "upnp-${name}";
      value = {
        description = "Port mapping for ${value.description}.";
        enable = value.enable;
        bindsTo = value.services;
        wantedBy = value.services;
        path = [ pkgs.miniupnpc ];
        script = ''
          ${if value.overwrite then "${stopCommand} || true" else "# not overwriting"}
          ${startCommand}
        '';
        preStop = stopCommand;
      };
    }) config.networking.upnp;
  };
}
