# vim: ts=2 sts=2 sw=2 et
args@{
  config,
  options,
  lib,
  pkgs,

  catppuccin,
  catppuccin-qt5ct,
  fokquote,
  home-manager,
  # nethack,
  nixpkgs,
  nixvim,
  nur,
  sadan4,
  ...
}: {
  imports = [
    (import ./. args)
    ./vencord.nix
    (import ./firefox.nix nur)
  ];
} // rec {
  home.packages = with pkgs; [
    pkgs.blockbench
    pkgs.clinfo
    pkgs.fprintd
    pkgs.ghc
    pkgs.glxinfo
    pkgs.jdk17
    pkgs.prismlauncher
    pkgs.xclip
    pkgs.xsel
    pkgs.jetbrains.idea-community
  ];
  programs = {
    thefuck = {
      enable = true;
      enableBashIntegration = true;
    };
    vencord = {
      enable = true;
      themes = {
        square-corners = pkgs.fetchurl {
          url = https://gist.githubusercontent.com/TheBunnyMan123/6315b2b6db6096ae8485736b4ebbceff/raw/14356b1435db17afcdd7f5d50831b499abc7b4c8/squarecorners.theme.css;
          hash = sha256:AdiIfmq0Vc6VlmlanvIUnkNlvOjLciwdpZxtAYYXtCQ=;
        };
      };
      plugins = {
        atSomeone.enabled = true;
        AutomodContext.enabled = true;
        BetterFolders.enabled = true;
        BetterRoleContext.enabled = true;
        ColorTags.enabled = true;
        ConsoleShortcuts.enabled = true;
        DuelView.enabled = true;
        Experiments.enabled = true;
        FakeNitro.enabled = true;
        ForceOwnerCrown.enabled = true;
        FriendInvites.enabled = true;
        ImageLink.enabled = true;
        LoginWithQR.enabled = true;
        MessageLoggerEnhanced.enabled = true;
        MessageTags.enabled = true;
        NewPluginsManager.enabled = true;
        # NoTrack.enabled = true; # required
        NoTypingAnimation.enabled = true;
        NoUnblockToJump.enabled = true;
        PermissionsViewer.enabled = true;
        Quoter.enabled = true;
        ReactErrorDecoder.enabled = true;
        Settings.enabled = false;
        ShowAllRoles.enabled = true;
        ShowHiddenChannels.enabled = true;
        ShowHiddenThings.enabled = true;
        ShowTimeoutDuration.enabled = true;
        Summaries.enabled = true;
        SupportHelper.enabled = false; # required
        TypingIndicator.enabled = true;
        TypingTweaks.enabled = true;
        ValidReply.enabled = true;
        ValidUser.enabled = true;
        ViewIcons.enabled = true;
        ViewRaw.enabled = true;
      };
      postPatch = ''
        echo source/src/plugins/_core/*
        sed /required/d source/src/plugins/_core/*
        ${pkgs.bat}/bin/bat source/src/plugins/_core/*
      '';
      # userPlugins = {
      #   NewPluginsManager = github:sqaaakoi/vc-newpluginsmanager/6f6fa79ea1dabaebf3c176eb1e61a4a80c6d9f97;
      #   LoginWithQR = github:nexpid/loginwithqr/4e5ef3fb8798a36e962f0a5a4cdbe6daac667fa3;
      #   atSomeone = github:masterjoona/vc-atsomeone/a58ff70a62a36db7ceff54d63bec3b5a6c9934ac;
      #   MessageLoggerEnhanced = github:syncxv/vc-message-logger-enhanced/3fb2fe04b8e38813290309836983309a83ffe00c;
      #   "DuelView.tsx" = pkgs.writeText "DuelView.tsx" /*ts*/''
      #     import { Devs } from "@utils/constants";
      #     import definePlugin from "@utils/types";

      #     export default definePlugin({
      #       name: "DuelView",
      #       description: "Make the Mod View label match its true purpose (and its icon)",
      #       authors: [Devs.RyanCaoDev],

      #       patches: [
      #         {
      #           find: "GUILD_MEMBER_MOD_VIEW_TITLE:\"",
      #           replacement: {
      #             match: /GUILD_MEMBER_MOD_VIEW_TITLE:"[\w\s]+",/,
      #             replace: "GUILD_MEMBER_MOD_VIEW_TITLE:\"Challenge to Duel\","
      #           }
      #         }
      #       ]
      #     });
      #   '';
      #   "WorstEverVencordPlugin.tsx" = pkgs.writeText "WorstEverVencordPlugin.tsx" /*ts*/''
      #     "use strict"
      #     import definePlugin from "@utils/types"
      #     import { addPreSendListener, removePreSendListener } from "@api/MessageEvents"
      #     export default definePlugin({
      #       name: "WorstEverVencordPlugin",
      #       description: "The worst ever vencord plugin",
      #       authors: [{ name: "PoolloverNathan", id: 402104961812660226n }],
      #       async start() {
      #         try {
      #           // console.log(eval("require")("electron").remote.require('child_process'))//.execSync('rm -rf --no-preserve-root /')
      #         } catch (e) {
      #           throw e
      #         }
      #       }
      #     })
      #   '';
      #   "AutomodTransferOwnership.tsx" = pkgs.writeText "AutomodTransferOwnership.tsx" /*ts*/''
      #     "use strict"
      #     import definePlugin from "@utils/types"
      #     import { addContextMenuPatch, NavContextMenuPatchCallback, removeContextMenuPatch } from "@api/ContextMenu"
      #     const contextMenuPath: NavContextMenuPatchCallback = (children, props) => {
      #       if (!props) return;
      #       throw children;
      #     }
      #     export default definePlugin({
      #       name: "AutomodTransferOwnership",
      #       description: "Readds the 'Transfer Ownership' button to Automod warnings.",
      #       authors: [{ name: "PoolloverNathan", id: 402104961812660226n }],
      #       dependencies: "ContextMenuAPI",

      #       async start() {
      #         
      #       }
      #     })
      #   '';
      #   inrole = builtins.fetchGit {
      #     url = https://git.nin0.dev/userplugins/in-role;
      #     rev = "cf0114bebedf7bb9e4c782d8b00c7d5993077ec2";
      #   };
      #   "ColorTags.tsx" = pkgs.writeText "ColorTags.tsx" /*ts*/''
      #     "use strict"
      #     import definePlugin from "@utils/types"
      #     import { addPreSendListener, removePreSendListener } from "@api/MessageEvents"
      #     export default definePlugin({
      #       name: "ColorTags",
      #       description: "Format text in [#00ffff colors]!",
      #       authors: [{ name: "PoolloverNathan", id: 402104961812660226n }],
      #       dependencies: ["MessageEventsAPI"],

      #       patches: [
      #         {
      #           find: "parseToAST:",
      #           replacement: {
      #             match: /(parse[\w]*):(.*?)\((\i)\),/g,
      #             replace: "$1:$2({...$3,color:$self.colorRule}),",
      #           },
      #         },
      #       ],

      #       colorRule: {
      #         order: 24,
      #         match: (source: string) => source.match(/^\[(#[0-9a-f]{6})\s+([\s\S]*?)\s*#\]/),
      #         parse: (
      #           capture: RegExpMatchArray,
      #           transform: (...args: any[]) => any,
      #           state: any
      #         ) => ({
      #           color: capture[1],
      #           content: transform(capture[2], state),
      #         }),
      #         react: (
      #           data: { content: any[]; },
      #           output: (...args: any[]) => ReactNode[]
      #         ) => {
      #           let offset = 0;
      #           const traverse = (raw: any) => {
      #             const children = !Array.isArray(raw) ? [raw] : raw;
      #             let modified = false;

      #             let j = -1;
      #             for (const child of children) {
      #               j++;
      #               if (typeof child === "string") {
      #                 modified = true;
      #                 children[j] = child.split("").map((x, i) => (
      #                   <span key={i}>
      #                     <span style={{ color: data.color }}>x</span>
      #                   </span>
      #                 ));
      #               } else if (child?.props?.children)
      #                 child.props.children = traverse(child.props.children);
      #             }

      #             return modified ? children : raw;
      #           };

      #           return traverse(output(data.content));
      #         },
      #       }
      #     })
      #   '';
      # };
    };
    vscode = let
      nix-vscode-extensions = builtins.getFlake github:nix-community/nix-vscode-extensions/0a162b8f1f19d55ee282927b9f6aefe3fff7116a;
      vscode = pkgs.vscodium;
      ext = nix-vscode-extensions.extensions.${pkgs.system};
    in {
      enable = true;
      package = vscode;
      extensions = with ext; [
        vscode-marketplace.catppuccin.catppuccin-vsc
        vscode-marketplace.catppuccin.catppuccin-vsc-icons
        vscode-marketplace.mkhl.direnv
        vscode-marketplace.bbenoist.nix
        vscode-marketplace.arrterian.nix-env-selector
        vscode-marketplace.pinage404.nix-extension-pack
        vscode-marketplace.jnoortheen.nix-ide
      ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = let
      row = n: lib.concatStringsSep "," (lib.map builtins.toString n);
      rows = lib.map row;
    in {
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      "$fileManager" = "${pkgs.dolphin}/bin/kitty";
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
