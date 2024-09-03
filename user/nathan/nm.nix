{ pkgs, lib, config, ... }: let 
  aos = a: with lib.types; attrsOf (submodule a);
  nm = config.programs.nm;
in {
  options.programs.nm = {
    enable = lib.mkEnableOption "NixMinecraft";
    accounts = lib.mkOption {
      description = "Accounts that can be used for Minecraft instances. If authentication is required for an account, it can be triggered using `nm-auth` and its token will be stored in the system keychain.";
      default = {};
      type = aos {

      };
    };
    defaultAccount = let
      accountNames = builtins.attrNames nm.accounts;
    in lib.mkOption {
      description = "The account to use by default, unless overridden by an instance. Must be set if two or more accounts are specified.";
      type = types.enum accountNames;
      default =
        if builtins.length accountNames == 1 then
          builtins.throw "Either programs.nm.defaultAccount must be set or each instance must have its own defaultAccount specified unless there is exactly one registered account."
        else
          builtins.elemAt accountNames 0;
    };
  };
}
