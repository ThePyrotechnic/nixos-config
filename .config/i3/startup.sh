killall -q .polybar-wrapper polybar
polybar primary --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown
polybar secondary --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown
