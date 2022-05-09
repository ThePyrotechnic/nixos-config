#!/usr/bin/env bash

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
	--delay 0.1 \
        --scrollpadding " - " \
        --matchcommand "`dirname $0`/get_spotify_status.sh --status" \
        --matchtext "Playing" -s 1 \
        --matchtext "Paused" -s 0 \
        --updatecheck \
	"`dirname $0`/get_spotify_status.sh" &
wait

