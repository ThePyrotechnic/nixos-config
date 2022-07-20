# https://discourse.nixos.org/t/how-to-edit-file-in-nix-store/19261
{pkgs, lib, ...}: let
  horizon-client = pkgs.vmware-horizon-client.overrideAttrs (oldAttrs: rec {
    version = "2111";
    src = builtins.fetchurl {
      url = "https://download3.vmware.com/software/view/viewclients/CART22FH2/VMware-Horizon-Client-Linux-2111-8.4.0-18957622.tar.gz";
      sha256 = "2f79d2d8d34e6f85a5d21a3350618c4763d60455e7d68647ea40715eaff486f7";
    };
  });
in {
  environment.systemPackages = [
    horizon-client
  ];
}
