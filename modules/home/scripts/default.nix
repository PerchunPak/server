{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      set -ex
      trap 'cd -' EXIT

      cd ~/dotfiles
      git pull
      sudo true
      nh os switch "$@"
    '')

    (pkgs.writeShellScriptBin "modify" ''
      set -ex
      mv "$1" "$1"1
      cat "$1"1 > "$1"
    '')

    (pkgs.writeShellScriptBin "modifyu" ''
      set -ex
      mv "$1" "$1".modified
      mv "$1"1 "$1"
    '')

    (pkgs.writeShellScriptBin "rollback" ''
      set -ex
      sudo nix-env --switch-generation "$1" -p /nix/var/nix/profiles/system
      sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    '')
  ];
}
