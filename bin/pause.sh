#!/usr/bin/env bash

if [ -z "$1" ]; then
  target=$(xprop -id $(xdotool getwindowfocus) _NET_WM_PID | grep -o -E '[0-9]+')
else
  target=$(pgrep --newest $1)
fi
echo "target: $target"
state=$(ps -o stat= -q $target)

if [[ $state == *T* ]]; then
  kill -s CONT $target
  echo "resuming"
else
  kill -s STOP $target
  echo "pausing"
fi
 
