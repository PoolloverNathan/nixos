# vim: ts=2 sts=2 sw=2 et
{
  catppuccin,
  fokquote,
  home-manager,
  lib,
  # nethack,
  nixvim,
  pkgs,
  sadan4,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
    catppuccin.homeManagerModules.catppuccin
  ];
  system.hashedPassword = "$y$j9T$lfDMkzctZ7jVUA.rK6U/3/$stLjTnRqME75oum.040Ya7tKAPsnIJ.gAZYQk57vNp2";
  system.userDescription = "PoolloverNathan";
  catppuccin = {
    enable = true;
    flavor = "frappe";
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
      inherit vencord;
    };
    vencord = (import "${sadan4}/customPackages" { inherit pkgs; }).vencord.overrideAttrs {
      # patches = [./vencord-no-required.patch];
      # patchFlags = ["-p0"];
    };
    fok-quote = fokquote.packages.${pkgs.system}.default;
  };
  programs = {
    bash = {
      enable = true;
      historyControl = ["erasedups" "ignorespace"];
      historySize = 0;
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
