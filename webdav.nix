{ ... }: {
  services.nginx.virtualHosts = {
    "dav.pool.net.eu.org" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        extraConfig = /*nginx*/''
          add_header 'Access-Control-Allow-Origin' 'app.keeweb.info' always;
          add_header 'Access-Control-Allow-Credentials' 'true' always;
          add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
          add_header 'Access-Control-Allow-Headers' 'Keep-Alive,If-Modified-Since,Cache-Control,Content-Type' always;
          add_header 'Access-Control-Max-Age' 1728000 always; # 20 days
          if ($request_method = 'OPTIONS') {
            add_header 'Content-Length' 0;
            return 204;
          }
          proxy_pass http://100.100.100.100:8080;
          add_header 'Access-Control-Allow-Origin' 'app.keeweb.info' always;
          add_header 'Access-Control-Allow-Credentials' 'true' always;
          add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
          add_header 'Access-Control-Allow-Headers' 'Keep-Alive,If-Modified-Since,Cache-Control,Content-Type' always;
          add_header 'Access-Control-Max-Age' 1728000 always; # 20 days
        '';
      };
    };
  };
}
