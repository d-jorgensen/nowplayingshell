#!/bin/bash
title2=" "
status2= " "
B_RED=$'\033[1;31m'
B_CYAN=$'\033[1;36m'
RESET=$'\033[0m'

while true; do
  # if spotify is started
  if [ "$(pidof spotify)" ]; then
    status=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | egrep -A 1 "string" | cut -b 26- | cut -d '"' -f 1 | egrep -v ^$)
    title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 1 "title" | egrep -v "title" | cut -b 44- | cut -d '"' -f 1 | egrep -v ^$)
  fi
  if [[ "$title" != "$title2" || "$status" != "$status2" ]]; then
    title2=$title
    status2=$status
    # status can be: Playing, Paused or Stopped
    artist=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 2 "artist" | egrep -v "artist" | egrep -v "array" | cut -b 27- | cut -d '"' -f 1 | egrep -v ^$)
    album=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 1 "album" | egrep -v "album" | cut -b 44- | cut -d '"' -f 1 | egrep -v ^$)
    art=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 1 "artUrl" | egrep -v "artUrl" | cut -b 44- | cut -d '"' -f 1 | egrep -v ^$)

    clear
    printf "\n\n\n"
    printf "%-8s ${B_RED}%18.18s${RESET}\n" " " "$status"
    printf "%-8s ${B_CYAN}%18.18s${RESET}\n" "Artist:" "$artist"
    printf "%-8s ${B_CYAN}%18.18s${RESET}\n" "Album:" "$album"
    printf "%-8s ${B_CYAN}%18.18s${RESET}\n" "Title:" "$title"
    curl -sL "$art" | kitty +kitten icat --place 20x20@28x0 --fit both
  fi

  sleep 2
done
