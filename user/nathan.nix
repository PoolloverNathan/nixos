# vim: ts=2 sts=2 sw=2 et
{
  catppuccin,
  fokquote,
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
    emacs
    fastfetch
    firefox
    fprintd
    gh
    ghc
    glxinfo
    htop
    jdk17
    # kde-connect
    kitty
    prismlauncher
    python312Full
    thefuck
    tmux
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
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    plugins.lightline.enable = true;
  };
}
