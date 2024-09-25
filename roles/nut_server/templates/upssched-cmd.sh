#! /usr/bin/env bash

notify() {
  MESSAGE="{{ nut_server_ups_name }}@{{ ansible_hostname }} - $1"
  curl -d "$MESSAGE" "{{ nut_server_ntfy }}"
}

case $1 in
notify-no-comm)
  notify "unavailable"
  ;;
notify-comm-bad)
  notify "communication lost"
  ;;
notify-comm-ok)
  notify "communication restored"
  ;;
notify-fsd)
  notify "forced to shutdown"
  ;;
notify-low-battery)
  notify "low battery"
  ;;
notify-on-battery)
  notify "on battery"
  ;;
notify-online)
  notify "on line"
  ;;
notify-replace-battery)
  notify "replace battery"
  ;;
notify-shutdown)
  notify "host shutting down"
  ;;
shutdown)
  shutdown -P now
  ;;
*)
  notify "unrecognized command $1"
  ;;
esac
