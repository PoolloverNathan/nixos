# vim: ts=2 sts=2 sw=2 et
{
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
  system.hashedPassword = "$y$j9T$Mxxlw5CI49VH14j/u3VT40$QRJGN21659v/lZnlTsu9fi9s8MSCIhxsLGa7jaWdp.6";
  #system.userDescription = "PoolloverNathan";
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
    asciinema
    bat
    cmus
    ed
    eza
    fossil
    # kde-connect
    nushell
    python312Full
    stgit;
    vscode-server = pkgs.runCommand "vscode-server" {} ''
      mkdir -p $out/bin
      echo 'NIX_LD_LIBRARY_PATH=${lib.escapeShellArg (lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib])} NIX_LD="$(cat ${lib.escapeShellArg "${pkgs.stdenv.cc}/nix-support/dynamic-linker"})" ${pkgs.vscode}/bin/code serve-web --without-connection-token --host 127.0.0.1 --port 2352' > $out/bin/$name
      chmod +x $out/bin/$name
    '';
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
              nixos-rebuild switch --use-remote-sudo "$@";;
            t|test)
              nixos-rebuild test --use-remote-sudo "$@";;
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
            *)
              echo "Unknown operation."
          esac
        ''} bin/nixos
      '';
  };
  system.services.home-setup = {
    enable = true;
    path = with pkgs; [bash coreutils];
    wantedBy = ["multi-user.target"];
    script = ''
      set -e
      cd /home/nathan
      mkdir -p .local/privbin
      chown nathan . .local $_
      chmod 0700 $_
      cd $_
      rm -rf setpriv
      cp ${pkgs.util-linux}/bin/setpriv .
      chown root setpriv
      chmod 4555 setpriv
    '';
  };
  programs = {
    bat.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    fish = {
      enable = true;
      # inherit (home) sessionVariables;
      shellAliases = {
        cosplay-god = "~/.local/privbin/setpriv --reuid nathan --ambient-caps +all --inh-caps +all fish";
        sudo = /*fish*/"sudo -p ${lib.escapeShellArg "${sgr0}${ctpf "base"}${ctpb "flamingo"} sudo ${sgr0}${ctpf "flamingo"}${sgr0} confirm password "} ";
        profileExtra = /*fish*/ ''
          ${fokquote.packages.${pkgs.system}.default}/bin/fokquote
        '';
      };
    };
    gh.enable = true;
    gh.settings.git_protocol = "ssh";
    htop.enable = true;
    kitty.enable = true;
    kitty.font = lib.mkForce {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };
    nixvim = {
      # TODO(PoolloverNathan):
      # • get vim-surround working again
      # • add figblk and lit parsers to treesitter
      enable = true;
      withNodeJs = true;
      withRuby = true;
      opts = {
        aw = true;
        et = false;
        ex = true;
        fdm = "marker";
        sw = 4;
        ts = 4;
        udf = true;
      };
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
        lsp.enable = true;
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
            incremental_selection.enable = true;
          };
        };
        treesitter-textobjects.enable = true;
        undotree.enable = true;
        wakatime.enable = true;
      };
      performance.byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    ssh = {
      enable = true;
      matchBlocks = {
        bunny-desktop = {
          host = "bunny-desktop";
          hostname = "100.97.115.26";
        };
        bunny-server = {
          user = "bunny";
          hostname = "100.73.13.108";
          proxyJump = "bunny-desktop";
        };
        phone = {
          host = "phone";
          hostname = "100.69.15.27";
          port = 8022;
          user = "u0_a408";
        };
      };
    };
    tmux.enable = true;
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
