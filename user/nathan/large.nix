# vim: ts=2 sts=2 sw=2 et
{
  catppuccin,
  catppuccin-qt5ct,
  fokquote,
  home-manager,
  # nethack,
  nixpkgs,
  nixvim,
  nur,
  sadan4,

  config,
  options,
  lib,
  pkgs,
  ...
}@args: a: {
  imports = [
    (import ./interactive.nix args)
  ];
} // rec {
  home.packages = with pkgs; [
    pkgs.blockbench
    pkgs.ghc
    pkgs.jetbrains.idea-community
  ];
  programs = {
    nixvim = {
      withNodeJs = true;
      withRuby = true;
      plugins = {
        gitsigns.enable = true;
        lightline.enable = true;
        lsp.enable = true;
        #lsp.servers = lib.mapAttrs (k: v: { enable = true; }) (__trace (a.options.programs.nixvim.type.getSubOptions []) 1).plugins.lsp.servers;
        fzf-lua.enable = true;
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
