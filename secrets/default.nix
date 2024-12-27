{ ... }: {
  services.tailscale.authKeyFile = "/run/agenix/tailscale-auth";
  age.secrets = {
    tailscale-auth.file = ./tailscale-auth.age;
  };
}
