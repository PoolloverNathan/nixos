{
  nur,
  pkgs,
  lib,
  ...
}@args: {
  imports = [
    (import ./firefox.nix nur)
    (import ./default.nix args)
  ];
  home.packages = with pkgs; [
    pkgs.prismlauncher
    pkgs.clinfo
    pkgs.fprintd
    pkgs.glxinfo
    pkgs.jdk17
    pkgs.xclip
    pkgs.xsel
  ];
  services = {
    lorri.enable = true;
  };
  programs = {
    direnv = {
      enable = true;
      silent = true;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = let
      row = n: lib.concatStringsSep "," (lib.map builtins.toString n);
      rows = lib.map row;
    in {
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      "$fileManager" = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      exec = [
        
      ];
      exec-once = [
        "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
        "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-hyprland"
        "${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland"
      ];
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(85c1dcee) rgba(81c8beee) 45deg";
        "col.inactive_border" = "rgba(c6d0f5aa)";
        "col.nogroup_border" = "rgba(eebebeaa)";
        "col.nogroup_border_active" = "rgba(ea999cee) rgba(81c8beee) 45deg";
        resize_on_border = false;
        allow_tearing = true;
        layout = "dwindle";
      };
      group = {
        groupbar.enabled = false;
        "col.border_active" = "rgba(e5c890ee)";
        "col.border_locked_active" = "rgba(ef9f76ee)";
        "col.border_inactive" = "rgba(e5c890aa)";
        "col.border_locked_inactive" = "rgba(ef9f76aa)";
      };
      decoration = {
        rounding = 4;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      animations = {
        enabled = true;
        bezier = rows [
          ["myBezier" 0.05 0.9 0.1 1.05]
        ];
        animation = rows [
          ["windows" 1 7 "myBezier"]
          ["windowsOut" 1 7  "default" "popin 80%"]
          ["border" 1 10 "default"]
          ["borderangle" 1 8 "default"]
          ["fade" 1 7 "default"]
          ["workspaces" 1 6 "default"]
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master.new_status = "master";
      misc = {
        force_default_wallpaper = 0;
        enable_swallow = true;
        swallow_regex = "^kitty$";
      };
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = compose:main;
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };
      gestures.workspace_swipe = false;
      bind = rows [
        ["SUPER" "Q" "exec" "$terminal"]
        ["SUPER" "C" "killactive"]
        ["SUPER" "M" "exit"]
        ["SUPER" "U" "fullscreen" 1]
        ["SUPER SHIFT" "U" "fullscreen" 0]
        ["SUPER" "E" "exec" "$fileManager"]
        ["SUPER" "F" "toggleFloating" ""]
        ["SUPER SHIFT" "F" "pin" ""]
        ["SUPER" "B" "exec" "firefox"]
        ["SUPER" "R" "exec" "hyprctl reload"]
        ["SUPER" "P" "pseudo"]
        ["SUPER" "X" "exec" "hyprctl kill"]
        ["SUPER" "J" "togglesplit"]
        ["SUPER" "T" "exec" "${pkgs.hyprshot}/bin/hyprshot -m window"]
        ["SUPER SHIFT" "T" "exec" "${pkgs.hyprshot}/bin/hyprshot -m region"]
        ["SUPER CTRL" "T" "exec" "${pkgs.hyprshot}/bin/hyprshot -m output"]
        ["SUPER" "L" "exec" (lib.escapeShellArgs [
          "${pkgs.swaylock}/bin/swaylock"
          "--show-failed-attempts"
          "--indicator-caps-lock"
          "--show-keyboard-layout"
          "--ignore-empty-password"
          "--line-uses-inside"
          "--color=#232634"
          "--inside-color=#292c3c"
          "--ring-color=#414559"
          "--separator-color=#00000000"
          "--key-hl-color=#c6d0f5"
          "--caps-lock-key-hl-color=#c6d0f5"
          "--bs-hl-color=#ca9ee6"
          "--caps-lock-bs-hl-color=#ca9ee6"
          "--layout-bg-color=#00000000"
          "--layout-text-color=#b5bfe2"
          "--inside-clear-color=#292c3c"
          "--inside-caps-lock-color=#292c3c"
          "--inside-ver-color=#292c3c"
          "--inside-wrong-color=#292c3c"
          "--ring-clear-color=#c6a0f6"
          "--ring-caps-lock-color=#91d7e3"
          "--ring-ver-color=#a6da95"
          "--ring-wrong-color=#ed8796"
          "--text-color=#c6d0f5"
          "--text-clear-color=#c6a0f6"
          "--text-caps-lock-color=#91d7e3"
          "--text-ver-color=#a6da95"
          "--text-wrong-color=#ed8796"
        ])]
        ["SUPER" "left" "movefocus" "l"]
        ["SUPER" "right" "movefocus" "r"]
        ["SUPER" "up" "movefocus" "u"]
        ["SUPER" "down" "movefocus" "d"]
        ["CTRL SUPER" "left" "movewindow" "l"]
        ["CTRL SUPER" "right" "movewindow" "r"]
        ["CTRL SUPER" "up" "movewindow" "u"]
        ["CTRL SUPER" "down" "movewindow" "d"]
        ["ALT SUPER" "left" "moveintogroup" "l"]
        ["ALT SUPER" "right" "moveintogroup" "r"]
        ["ALT SUPER" "up" "moveintogroup" "u"]
        ["ALT SUPER" "down" "moveintogroup" "d"]
        ["SUPER" "G" "togglegroup"]
        ["SHIFT SUPER" "G" "moveoutofgroup"]
        ["ALT SUPER" "G" "lockgroups" "toggle"]
        ["SUPER" "comma" "changegroupactive" "b"]
        ["SUPER" "period" "changegroupactive" "f"]
        ["CTRL SUPER" "comma" "movegroupwindow" "b"]
        ["CTRL SUPER" "period" "movegroupwindow" "f"]
        ["SUPER" "pause" "exec" "${pkgs.cmus}/bin/cmus-remote -u"]
        ["SUPER" "prior" "exec" "${pkgs.cmus}/bin/cmus-remote -r"]
        ["SUPER" "next"  "exec" "${pkgs.cmus}/bin/cmus-remote -n"]
        ["CTRL SUPER" "prior" "exec" "${pkgs.cmus}/bin/cmus-remote -v +5%"]
        ["CTRL SUPER" "next"  "exec" "${pkgs.cmus}/bin/cmus-remote -v -5%"]
        ["SUPER" 1 "workspace"  1]
        ["SUPER" 2 "workspace"  2]
        ["SUPER" 3 "workspace"  3]
        ["SUPER" 4 "workspace"  4]
        ["SUPER" 5 "workspace"  5]
        ["SUPER" 6 "workspace"  6]
        ["SUPER" 7 "workspace"  7]
        ["SUPER" 8 "workspace"  8]
        ["SUPER" 9 "workspace"  9]
        ["SUPER" 0 "workspace" 10]
        ["SUPER SHIFT" 1 "movetoworkspace"  1]
        ["SUPER SHIFT" 2 "movetoworkspace"  2]
        ["SUPER SHIFT" 3 "movetoworkspace"  3]
        ["SUPER SHIFT" 4 "movetoworkspace"  4]
        ["SUPER SHIFT" 5 "movetoworkspace"  5]
        ["SUPER SHIFT" 6 "movetoworkspace"  6]
        ["SUPER SHIFT" 7 "movetoworkspace"  7]
        ["SUPER SHIFT" 8 "movetoworkspace"  8]
        ["SUPER SHIFT" 9 "movetoworkspace"  9]
        ["SUPER SHIFT" 0 "movetoworkspace" 10]
        ["SUPER" "Z" "movetoworkspacesilent" special:minimized]
        ["SUPER SHIFT" "Z" "togglespecialworkspace" "minimized"]
        ["SUPER SHIFT" "Z" "submap" "minimized"]
        ["SUPER" "S" "togglespecialworkspace" "magic"]
        ["SUPER SHIFT" "S" "togglespecialworkspace" special:magic]
        ["SUPER" "mouse_down" "workspace" "e+1"]
        ["SUPER" "mouse_up" "workspace" "e-1"]
      ];
      bindm = rows [
        ["SUPER" mouse:272 "movewindow"]
        ["SUPER" mouse:273 "resizewindow"]
      ];
      windowrulev2 = rows [
        ["suppressevent maximize" class:.*]
      ];
    };
  };
}
