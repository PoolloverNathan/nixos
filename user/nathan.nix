# vim: ts=2 sts=2 sw=2 et
{
  config,
  lib,
  pkgs,

  catppuccin,
  fokquote,
  home-manager,
  # nethack,
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
  ];
  system.hashedPassword = "$y$j9T$lfDMkzctZ7jVUA.rK6U/3/$stLjTnRqME75oum.040Ya7tKAPsnIJ.gAZYQk57vNp2";
  system.userDescription = "PoolloverNathan";
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
    # inherit (pkgs.jetbrains)
    # idea-community;
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
      # inherit vencord;
    };
    # vencord = (import "${sadan4}/customPackages" { inherit pkgs; }).vencord.overrideAttrs {
    #   # patches = [./vencord-no-required.patch];
    #   # patchFlags = ["-p0"];
    # };
    fok-quote = fokquote.packages.${pkgs.system}.default;
  };
  # let powerline access catppuccin
  home.file.".config/powerline/colors.json".text = builtins.toJSON {
    colors = lib.mapAttrs (_: { hex, ... }: [27 (builtins.substring 1 6 hex)]) ctpPalette;
    gradients = {};
  };
  home.file.".config/powerline/colorschemes/catppuccin.json".text = builtins.toJSON {
    ext.bash.colorscheme = "catppuccin";
    groups = {
      cwd = {
        fg = "text";
        bg = "surface0";
      };
      "cwd:divider" = {
        fg = "subtext";
        bg = "surface0";
      };
      "cwd:current_folder" = {
        fg = "text";
        bg = "surface0";
        attrs = ["bold"];
      };
    };
  };
  # home.file.".config/powerline/themes/"
  programs = {
    bash = {
      enable = true;
      historyControl = ["ignoredups" "ignorespace"];
      historySize = -1;
      shellAliases = {
        sudo = "sudo -p ${lib.escapeShellArg "${sgr0}${ctpf "base"}${ctpb "flamingo"} sudo ${ctpf "flamingo"}${ctpb "surface0"}${ctpf "text"} password for nathan ${sgr0}${ctpf "surface0"}${sgr0} "} ";
        nixos = (
          pkgs.writers.writeBash "nixos.sh" ''
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
                nixos-generate-config;;                                                                                          
              b|build|dry-build)                                                                                                       
                nixos-rebuild build "$@";;                                                                                       
              d|dry|dry-activate)                                                                                                      
                nixos-rebuild dry-activate;;
              u|up|update|upgrade)
                if [ $# == 0 ]; then
                  args=(--recreate-lock-file)
                else
                  args=()
                  for input; do
                    args+=(--update-input "$input")
                  done
                fi
                nix flake lock /etc/nixos "''${args[@]}";;
              reset)
                if [ -f /etc/NIXOS_LUSTRATE ]; then
                  echo "A reset is already scheduled. Reboot to confirm it."
                  exit 1
                fi
                tput bold rev setaf 1
                echo "!! DO NOT IGNORE THIS WARNING !!"
                tput sgr0
                echo -n "If you continue, all data in / that is not on another filesystem will be moved into /old-root/, and your system will be recreated from scratch. "
                tput bold setaf 1
                echo "ANY PASSWORD SET BY \`passwd\` WILL BE IGNORED. MAKE SURE YOU HAVE A PASSWORD DECLARED DECLARATIVELY, OR YOU WILL NOT BE ABLE TO LOG IN."
                tput sgr0
                sleep 5
                echo "The following files will be preserved:"
                dontwipe=`mktemp`
                (
                  [ -f /etc/wipe.dont ] && cat /etc/wipe.dont
                  echo /etc/nixos # terrible if lost
                ) | sed "s:^(?!=/):/:" | sort -u | tee "$dontwipe"
                echo "To continue, please type 'Yes, reset my system!'"
                read -p "!> "
                if [ "$REPLY" == "Yes, reset my system!" ]; then
                  mv "$dontwipe" /etc/NIXOS_LUSTRATE
                  echo "System marked for reset. Reboot to confirm."
                else
                  echo "Aborted."
                  exit 1
                fi;;
              viuser)
                eval "''${EDITOR?nano}" /etc/nixos/user/`whoami`.nix;;
              *)
                echo "Unknown operation."
            esac
          ''
          ).outPath;
      };
    };
    emacs.enable = true;
    fastfetch.enable = true;
    firefox.enable = true;
    gh.enable = true;
    htop.enable = true;
    kitty.enable = true;
    nixvim = {
      enable = true;
      colorschemes.catppuccin.enable = true;
      plugins.lightline.enable = true;
    };
    powerline-go = {
      enable = true;
      modules = ["exit" "jobs" "host" "cwd" "gitlite"];
      pathAliases."\\~" = "~";
      settings.alternate-ssh-icon = true;
    };
    ssh = {
      enable = true;
      matchBlocks = {
        bunny = {
          host = "nixos.kamori-ghoul.ts.net";
          port = 2222;
        };
      };
    };
    thefuck = {
      enable = true;
      enableBashIntegration = true;
    };
    tmux.enable = true;
  };
}
