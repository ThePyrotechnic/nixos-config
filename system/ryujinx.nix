# https://discourse.nixos.org/t/how-to-edit-file-in-nix-store/19261
{pkgs, lib, ...}: let
  # lutris-unwrapped is the "real" lutris. The lutris package that is
  # installed "wraps" the "real" lutris to make it actually work on
  # NixOS, but the source is compiled here.
  #
  # We use `overrideAttrs` to change the way the package is actually
  # built. In particular, this is because we want to override
  # something in the `stdenv.mkDerivation` call, this to be specific:
  #
  # https://github.com/NixOS/nixpkgs/blob/685d243d971c4f9655c981036b9c7bafdb728a0d/pkgs/applications/misc/lutris/default.nix#L131
  lutris-unwrapped = pkgs.lutris-unwrapped.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      # Work around https://github.com/NixOS/nixpkgs/issues/173712
      #
      # TODO: Remove once updated upstream
      (pkgs.fetchpatch {
        name = "fix-lutris-config.patch";
        # Note: Putting `.diff` at the end of a GitHub commit URL will
        # give us a nice patch we can just apply. Very handy!
        url = "https://github.com/lutris/lutris/commit/072e72a4aefd91101b79dd05d8ce9f100a4b6b0c.diff";
        sha256 = "0q7v0isa4zkhinl6yq0zm5dc40xk74y9lr0dg8x8klawkf49c7vb";
        # sha256 = lib.fakeSha256; # Put the checksum that nix complains to you about here
      })
    ];
  });
  # This is the lutris package we can actually install. It takes
  # lutris-unwrapped as an input, and then creates the usable package.
  #
  # We therefore need to override one of its arguments, rather than
  # its actual contents. We use `.override` for that. We override part
  # of this line:
  #
  # https://github.com/NixOS/nixpkgs/blob/685d243d971c4f9655c981036b9c7bafdb728a0d/pkgs/applications/misc/lutris/fhsenv.nix#L1
  lutris = pkgs.lutris.override {inherit lutris-unwrapped;};
in {
  environment.systemPackages = [
    # This is the lutris we created above. If you use `with pkgs;`, this will still work, `with` is confusing,
    # but in a nutshell it doesn't override anything we ourselves declare in the outer "scope".
    lutris
  ];
}
