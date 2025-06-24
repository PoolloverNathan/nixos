{ ... }: let
  host = "outline.pool.net.eu.org";
  port = 30089;
in {
  services.nginx.virtualHosts = {
    ${host} = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString port}";
        proxyWebsockets = true;
      };
    };
  };
  services.outline = {
    enable = true;
    forceHttps = false;
    port = port;
    publicUrl = "https://${host}";
    storage = {
      storageType = "local";
      localRootDir = "/var/lib/outline/data";
    };
    oidcAuthentication = {
      authUrl = https://discord.com/api/oauth2/authorize;
      clientId = "1320907864298229780";
      clientSecretFile = "/var/lib/outline/secret";
      displayName = "Discord";
      scopes = ["email" "identify" "openid"];
      tokenUrl = https://discord.com/api/oauth2/token;
      userinfoUrl = https://discord.com/api/users/@me;
    };
  };
}
