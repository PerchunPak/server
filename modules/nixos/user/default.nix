{ lib, config, ... }:
let
  cfg = config.my.user;
in
{
  options = {
    my.user = {
      password = lib.mkOption { type = with lib.types; passwdEntry str; };
    };
  };

  config = {
    users.users = {
      admin = {
        isNormalUser = true;
        hashedPassword = cfg.password;
        createHome = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "input"
        ];
      };
    };

    nix.settings.trusted-users = [ "@wheel" ];
  };
}
