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
}
