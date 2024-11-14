#!/usr/bin/env bash

set -euo pipefail

APP="all"
TASK="deploy"
LIMIT=""

usage() {
  echo "Usage: $0 [-a <app_name|all>] [-t <deploy|teardown|backup|restore>] [-l <ansible_host|ansible_group>]"
  exit 1
}

while getopts ":a:t:l:" opt; do
  case $opt in
  a)
    APP="$OPTARG"
    ;;
  t)
    TASK="$OPTARG"
    ;;
  l)
    LIMIT="$OPTARG"
    ;;
  *)
    usage
    ;;
  esac
done

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "ansible-playbook \"$SCRIPT_DIR/../playbooks/$APP.yml\" -i \"$SCRIPT_DIR/../inventory\" -e \"task=$TASK\" -l \"$LIMIT\" -v"
ansible-playbook \
  "$SCRIPT_DIR/../playbooks/$APP.yml" \
  -i "$SCRIPT_DIR/../inventory" \
  -e "task=$TASK" \
  -l "$LIMIT" \
  -v
