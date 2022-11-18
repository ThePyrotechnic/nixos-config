#!/usr/bin/env bash

mullvad connect
sleep 3
mullvad relay get
echo 'Use `mullvad relay list | less` and `mullvad relay set` to change locations'
mullvad status


