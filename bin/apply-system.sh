#!/usr/bin/env bash
pushd ~/system
sudo nixos-rebuild switch -I nixos-config=configuration.nix
popd
