ibus-daemon -d -x &
redshift -l 38:127 -t 6500:3500 &
dunst &
sh /home/youngjin/.screenlayout/layout.sh
xsetroot -solid '#504945'
xrdb ~/dot/Xresources.d/Xresources
setxkbmap -option ctrl:nocaps
exec i3
