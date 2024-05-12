#! /usr/bin/env bash
DEPLOY_PATH="{{ adguardhome_deploy_path }}"
BACKUP_PATH="{{ backup_path }}/adguardhome"
export COMPOSE_FILE="$DEPLOY_PATH/compose.yml"

function backup {
  echo "stopping adguardhome"
  docker compose down

  echo "copying files"
  cp -vr "$DEPLOY_PATH/work" "$BACKUP_PATH/"
  cp -vr "$DEPLOY_PATH/conf" "$BACKUP_PATH/"

  echo "starting adguardhome"
  docker compose up -d
}

function restore {
  echo "stopping adguardhome"
  docker compose down

  echo "copying files"
  cp -vr "$BACKUP_PATH/work" "$DEPLOY_PATH/"
  cp -vr "$BACKUP_PATH/conf" "$DEPLOY_PATH/"

  echo "starting adguardhome"
  docker compose up -d
}

if [[ $1 == restore ]]; then
  restore
else
  backup
fi
