# https://discourse.nixos.org/t/how-to-edit-file-in-nix-store/19261
{lib, ...}: let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/7d5956bf56e1f300c6668704b5e9c4cd8f5296cd.tar.gz";
  }) {};
  vmware-2111 = pkgs.vmware-horizon-client;
in {
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.systemPackages = [
    vmware-2111
  ];
}
