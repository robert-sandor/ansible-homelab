#! /usr/bin/env bash
set -eou pipefail

DEPLOY_PATH="{{ memos_deploy_path }}"
BACKUP_PATH="{{ backup_path }}/memos"
export COMPOSE_FILE="$DEPLOY_PATH/compose.yml"

function backup {
  echo "stopping memos"
  docker compose down

  echo "copying data files"
  cp -vr "$DEPLOY_PATH/data" "$BACKUP_PATH/"

  echo "starting memos"
  docker compose up -d
}

function restore {
  echo "ensure memos is down"
  docker compose down

  echo "copying data files"
  cp -vr "$BACKUP_PATH/data" "$DEPLOY_PATH/"

  echo "starting memos"
  docker compose up -d
}

if [[ ${1-backup} == restore ]]; then
  restore
else
  backup
fi
