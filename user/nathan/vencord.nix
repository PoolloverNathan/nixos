# vim: ts=2 sw=0 sts=0 et ft=nix
{ pkgs, lib, config, ... }: let
  dop = with lib.types; coercedTo package (a: a.outPath) pathInStore;
in {
  options.programs = {
    vencord = {
      enable = lib.mkEnableOption "Vencord";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.vencord;
      };
      settings = {
        enableReactDevtools = lib.mkEnableOption "React DevTools" // { default = true; };
        frameless = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to make the window frameless.";
          default = false;
        };
        transparent = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to make the window transparent.";
          default = false;
        };
        winCtrlQ = lib.mkOption {
          type = lib.types.bool;
          description = "Whether pressing Ctrl+Q should close the window.";
          default = false;
        };
        disableMinSize = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to disable the minimum window size.";
          default = false;
        };
        winNativeTitleBar = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to prefer the native window title bar.";
          default = false;
        };
      };
      postPatch = lib.mkOption {
        description = "Extra commands to run before compiling either Vencord or Vesktop.";
        type = lib.types.lines;
        default = "";
      };
      plugins = lib.mkOption {
        type = lib.types.attrs;
        description = "The plugins to enable, and their settings.";
        default = {};
        example = {
          MessageLogger.enabled = true;
          MessageClickActions = {
            enabled = true;
            enableDeleteOnClick = true;
          };
        };
      };
      themes = lib.mkOption {
        type = with lib.types; attrsOf (coercedTo lines (builtins.toFile "theme.css") dop);
        description = "The themes to make present in the Vencord directory.";
        default = {};
      };
      userPlugins = let
        regex = "github:([[:alnum:].-]+)/([[:alnum:].-]+)/([0-9a-f]{40})";
        coerce = value: let
          matches = builtins.match regex value;
          owner = builtins.elemAt matches 0;
          repo = builtins.elemAt matches 1;
          rev = builtins.elemAt matches 2;
        in builtins.fetchGit { url = "https://github.com/${owner}/${repo}"; inherit rev; };
      in
        lib.mkOption {
          type = with lib.types; attrsOf (coercedTo (strMatching regex) coerce dop);
          description = "User plugins to fetch and install. Note that they must be enabled in [programs.vencord.plugins] separately, and their name might not match the repository name.";
          default = {};
          example = {
            NewPluginsManager = github:Sqaaakoi/vc-newPluginsManager/6f6fa79ea1dabaebf3c176eb1e61a4a80c6d9f97;
          };
        };
    };
    vesktop = {
      enable = lib.mkEnableOption "Vesktop";
      package = lib.mkOption {
        type = lib.package;
        default = pkgs.vesktop;
      };
    };
  };
  config = let
    inherit (config.programs) vencord vesktop;
    combineDir = name: content: pkgs.runCommand name {} (lib.concatLines (lib.mapAttrsToList (name: src: "mkdir -p $out/${lib.escapeShellArg (builtins.dirOf name)} && cp ${lib.escapeShellArg content}) $out/${lib.escapeShellArg name}") content));
    applyPostPatch = pkg: pkg.overrideAttrs {
      inherit (vencord) postPatch;
    };
  in
    lib.mkIf (vencord.enable || vesktop.enable) {
      xdg.configFile = lib.mkMerge ([
        {
          "Vencord/settings/settings.json".text = builtins.toJSON ({
            autoUpdate = false;
            autoUpdateNotification = false;
            inherit (vencord) plugins;
            enabledThemes = lib.mapAttrsToList (name: value: "${name}.css") vencord.themes;
          } // vencord.settings);
        }
      ] ++ lib.mapAttrsToList (name: value: {
        "Vencord/themes/${name}.css".source = value;
      }) vencord.themes);
      programs.vencord.postPatch = lib.concatLines (lib.optional (vencord.userPlugins != {}) "mkdir -p src/userPlugins" ++ lib.mapAttrsToList (name: path: "ln -s ${lib.escapeShellArg path} src/userPlugins/${lib.escapeShellArg name}") vencord.userPlugins);
      home.packages =
        lib.optional vencord.enable (pkgs.discord.override { withVencord = true; vencord = applyPostPatch vencord.package; })
       ++ lib.optional vesktop.enable (applyPostPatch vesktop.package);
    };
}
