# vim: ts=2 sts=2 sw=2 et
{
  config,
  lib,
  pkgs,

  catppuccin,
  catppuccin-qt5ct,
  fokquote,
  home-manager,
  # nethack,
  nixpkgs,
  nixvim,
  sadan4,
  ...
}: let
  ctpPalette = let inherit (config.home-manager.users.nathan) catppuccin; in (lib.importJSON "${catppuccin.sources.palette}/palette.json").${catppuccin.flavor}.colors;
  ctpf = color: let inherit (ctpPalette.${color}.rgb) r g b; in "[38;2;${builtins.toString r};${builtins.toString g};${builtins.toString b}m";
  ctpb = color: let inherit (ctpPalette.${color}.rgb) r g b; in "[48;2;${builtins.toString r};${builtins.toString g};${builtins.toString b}m";
  sgr0 = "[0m";
in {
  imports = [
    nixvim.homeManagerModules.nixvim
    catppuccin.homeManagerModules.catppuccin
    ./vencord.nix
    {
      options.repl = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };
    }
  ];
} // rec {
  nixpkgs.config.allowUnfree = true;
  system.shell = pkgs.fish + /bin/fish;
  system.hashedPassword = "$y$j9T$lfDMkzctZ7jVUA.rK6U/3/$stLjTnRqME75oum.040Ya7tKAPsnIJ.gAZYQk57vNp2";
  system.userDescription = "PoolloverNathan";
  home.sessionVariables = {
    SHELL = "fish";
    EDITOR = "nvim";
  };
  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "sky";
  };
  home.stateVersion = "24.11";
  home.packages = builtins.attrValues rec {
    inherit (pkgs)
    blockbench
    clinfo
    ed
    fprintd
    ghc
    glxinfo
    jdk17
    # kde-connect
    prismlauncher
    python312Full
    vscodium
    xclip
    xsel;
    # nethack_ = nethack.packages.${pkgs.system}.default;
    inherit (pkgs.jetbrains)
    idea-community;
    nixos =
      pkgs.runCommand "nixos" {} ''
        mkdir -p $out/{bin,etc/fish/completions}
        cd $out
        cp ${pkgs.writers.writeBash "nixos-bin" ''
          set -euo pipefail
          op="$1"
          shift
          alias tput="tty -s && tput"
          case "$op" in
            rb|rebuild|sw|switch)
              nixos-rebuild switch "$@";;
            t|test)
              nixos-rebuild test "$@";;
            gen)
              nixos-generate-config "$@";;
            b|build|dry-build)
              nixos-rebuild build "$@";;
            d|dry|dry-activate)
              nixos-rebuild dry-activate;;
            repl|i)
              nixos-rebuild repl;;
            u|up|update|upgrade)
              if [ $# == 0 ]; then
                args=(--recreate-lock-file)
              else
                args=()
                for input; do
                  args+=(--update-input "$input")
                done
              fi
              nix flake lock /etc/nixos --commit-lock-file "''${args[@]}";;
            viuser)
              eval "''${EDITOR-nano}" /etc/nixos/user/`whoami`.nix;;
            *)
              echo "Unknown operation."
          esac
        ''} bin/nixos
        cp ${builtins.toFile "nixos-completions.fish" /*fish*/''
          begin
            set c complete -c nixos
            set cmd_switch rb rebuild sw switch
            set cmd_test t test
            set cmd_swtest $cmd_switch $cmd_test
            set cmd_build b build dry-build
            set cmd_dry d dry dry-activate
            set cmd_up u up update upgrade
            set cmds $cmd_swtest $cmd_build $cmd_dry $cmd_up
            $c -n "not __fish_seen_subcommand_from $cmds" -a "$cmds"
            $c -n "__fish_seen_subcommand_from $cmd_switch" -w "nixos-rebuild switch"
            $c -n "__fish_seen_subcommand_from $cmd_test" -w "nixos-rebuild test"
            $c -n "__fish_seen_subcommand_from $cmd_build" -w "nixos-rebuild build"
            $c -n "__fish_seen_subcommand_from $cmd_dry" -w "nixos-rebuild dry-activate"
          end
        ''} etc/fish/completions/nixos.fish
      '';
  };
  # Minecraft assets
  home.file.".local/share/mc-assets/1.20.1".source = pkgs.fetchFromGitHub {
    name = "mc1.20.1";
    owner = "inventivetalentdev";
    repo = "minecraft-assets";
    rev = "af628ec0e7977ec2f07c917d51413b4618a8cfcc";
    hash = sha256:q0ovpCikJ+vxbnMvtHvMfUO0o1/OBGlS9X7CmTpNIgw=;
  };
  programs = {
    fish = {
      enable = true;
      # inherit (home) sessionVariables;
      shellAliases = {
        sudo = /*fish*/"sudo -p ${lib.escapeShellArg "${sgr0}${ctpf "base"}${ctpb "flamingo"} sudo ${sgr0}${ctpf "flamingo"}${sgr0} confirm password "} ";
        profileExtra = /*fish*/ ''
          ${fokquote.packages.${pkgs.system}.default}/bin/fokquote
        '';
      };
    };
    emacs.enable = true;
    fastfetch.enable = true;
    gh.enable = true;
    gh.settings.git_protocol = "ssh";
    htop.enable = true;
    kitty.enable = true;
    kitty.font = lib.mkForce {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
      };
    };
    nixvim = {
      enable = true;
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = catppuccin.flavor;
          disable_italic = true;
          custom_highlights = /*lua*/''
            function(colo)
              return {
                ModeMsg = {
                  fg = colo.base;
                  bg = colo.base;
                };
              }
            end
          '';
          integrations = {
            gitsigns = true;
          };
        };
      };
      plugins = {
        gitsigns.enable = true;
        lightline.enable = true;
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
            incremental_selection.enable = true;
          };
        };
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    ssh = {
      enable = true;
      matchBlocks = {
        bunny = {
          host = "bunny";
          hostname = "nixos-desktop.kamori-ghoul.ts.net";
          port = 2222;
        };
      };
    };
    thefuck = {
      enable = true;
      enableBashIntegration = true;
    };
    tmux.enable = true;
    vencord = {
      enable = true;
      themes = {
        catppuccin = pkgs.fetchurl {
          url = "https://catppuccin.github.io/discord/dist/catppuccin-${catppuccin.flavor}-${catppuccin.accent}.theme.css";
          hash = sha256:uaYo7x0YHw0dJlzP6loIiQFxCU4HPvAUwiqQnaTZxn4=;
        };
      };
      plugins = {
        atSomeone.enabled = true;
        AutomodContext.enabled = true;
        BetterFolders.enabled = true;
        BetterRoleContext.enabled = true;
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
        NoTrack.enabled = true; # required
        NoTypingAnimation.enabled = true;
        NoUnblockToJump.enabled = true;
        PermissionsViewer.enabled = true;
        Quoter.enabled = true;
        ReactErrorDecoder.enabled = true;
        Settings.enabled = true; # required
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
      userPlugins = {
        NewPluginsManager = github:sqaaakoi/vc-newpluginsmanager/6f6fa79ea1dabaebf3c176eb1e61a4a80c6d9f97;
        LoginWithQR = github:nexpid/loginwithqr/4e5ef3fb8798a36e962f0a5a4cdbe6daac667fa3;
        atSomeone = github:masterjoona/vc-atsomeone/a58ff70a62a36db7ceff54d63bec3b5a6c9934ac;
        MessageLoggerEnhanced = github:syncxv/vc-message-logger-enhanced/3fb2fe04b8e38813290309836983309a83ffe00c;
        "DuelView.tsx" = pkgs.writeText "DuelView.tsx" /*ts*/''
          import { Devs } from "@utils/constants";
          import definePlugin from "@utils/types";

          export default definePlugin({
            name: "DuelView",
            description: "Make the Mod View label match its true purpose (and its icon)",
            authors: [Devs.RyanCaoDev],

            patches: [
              {
                find: "GUILD_MEMBER_MOD_VIEW_TITLE:\"",
                replacement: {
                  match: /GUILD_MEMBER_MOD_VIEW_TITLE:"[\w\s]+",/,
                  replace: "GUILD_MEMBER_MOD_VIEW_TITLE:\"Challenge to Duel\","
                }
              }
            ]
          });
        '';
      };
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
  qt = {
    enable = true;
    # required for catppuccin somehow
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
  # systemd.user.services.vscode-server = {
  #   Unit.Description = "Visual Studio Code web server (port 2352)";
  #   Install.WantedBy = ["default.target"];
  #   Service.ExecStart = "${pkgs.writers.writeBash "start-vscode-server" ''
  #     NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix-shell ${pkgs.writeText "vscode-server.nix" /*nix*/''
  #       with import ${nixpkgs.outPath} {};
  #       mkShell {
  #         buildInputs = [vscode nodejs nix gcc];
  #         shellHook = "code serve-web --without-connection-token --host 0.0.0.0 --port 2352";
  #         NIX_LD = lib.fileContents "''${stdenv.cc}/nix-support/dynamic-linker";
  #         NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [stdenv.cc.cc.lib];
  #       }
  #     ''}
  #   ''}";
  # };
}
