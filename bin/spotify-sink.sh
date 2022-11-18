#!/usr/bin/env bash
pulsemixer --list-sinks | python -c "import re,sys;print(re.search(r'ID: (.*), Name: spotify', sys.stdin.read()).group(1))"

