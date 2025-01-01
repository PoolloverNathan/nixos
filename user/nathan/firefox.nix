nur:
{ config, pkgs, ... }:
let
  lock = b: {
    Value = b;
    Status = "locked";
  };
  ext = id: install_url: {
    ${id} = {
      inherit install_url;
      installation_mode = "normal_installed";
    };
  };
in
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      containers.school = {
        color = "red";
        icon = "fruit";
      };
      extensions = with (nur.overlay pkgs pkgs).nur.repos.rycee.firefox-addons; [
        firefox-color
        sidebery
        sponsorblock
        stylus
        tampermonkey
        ublock-origin
        # wakatime
      ];
    };
  };
}
