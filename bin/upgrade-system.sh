#!/usr/bin/env bash
echo 'nix-channel --add https://nixos.org/channels/nixos-<version> nixos'
echo 'nix-channel --update'
echo 'Then change the system.stateVersion AFTER reading the update notes'
echo 'Then rebuild'

