# vim: ts=2 sts=2 sw=2 et
{
  sadan4 ? builtins.fetchTarball (https://github.com/sadan4/dotfiles/archive/refs/heads/main.tar.gz),
  fokquote ? builtins.getFlake (git+ssh://foko@foko-pc/home/foko/Flakes/FokQuote),
  ...
}: {
  pkgs ? import <nixpkgs> {},
  ...
}: {
  home.stateVersion = "24.11";
  home.packages = builtins.attrValues rec {
    inherit (pkgs)
    blockbench
    clinfo
    ed
    emacs
    firefox
    fprintd
    gh
    ghc
    glxinfo
    htop
    jdk17
    # kde-connect
    kitty
    neovim
    prismlauncher
    python312Full
    thefuck
    vscodium
    xclip
    xsel;
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
}
