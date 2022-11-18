#!/usr/bin/env bash

pushd '/nvmestorage/osu'
PULSE_LATENCY_MSEC=40 WINEPREFIX='/nvmestorage/osu' WINEARCH=win32 wine './drive_c/users/michael/AppData/Local/osu!/osu!' & disown
popd
