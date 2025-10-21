{
  networking = {
    firewall = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
    };
    upnp.dns = {
      enable = true;
      description = "dnsmasq";
      services = ["dnsmasq.service"];
      ports = [
        { port = 53; protocol = "tcp"; }
        { port = 53; protocol = "udp"; }
      ];
    };
    hosts = {
      "74.110.196.7" = ["chromebook.ccpsnet.net" "h.pool.net.eu.org"];
      #"0.0.0.0" = ["api.hapara.com" "hl.hapara.com"];
      "192.168.1.4" = ["home.vscode.local"];
      "192.168.143.69" = ["roaming.vscode.local"];
    };
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      server = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
  };
}
