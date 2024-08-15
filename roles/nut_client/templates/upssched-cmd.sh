#! /usr/bin/env bash

case $1 in
shutdown)
  shutdown -P now
  ;;
*)
  ech "unrecognized command $1"
  ;;
esac
