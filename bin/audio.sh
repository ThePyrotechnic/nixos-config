#!/usr/bin/env bash

pactl load-module module-jack-sink client_name=pulse_sink_2 connect=no
pactl load-module module-jack-source client_name=pulse_source_2 connect=no

