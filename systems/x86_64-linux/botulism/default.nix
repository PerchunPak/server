{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ./disko.nix { device = "/dev/sda"; })
  ];

  networking.hostName = "botulism";

  my = {
    user.password = "$y$j9T$1YPlnzEYbO2DKNH315Rx80$0Pz6NUYqmHGYMJ9KB0pEJ9Ph3hvWrRP8XV3HOap0q/1";
  };
}
