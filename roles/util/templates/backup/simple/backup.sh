#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ util_deploy_path }}"
BACKUP_PATH="{{ util_backup_path }}"
APP_NAME="{{ util_app }}"
COMPOSE_FILE="$DEPLOY_PATH/compose.yml"
STOP_SERVICES="{{ util_stop_services }}"

on_exit() {
  if ! docker compose -f "$COMPOSE_FILE" up -d; then
    echo "Error: Failed to restart $APP_NAME containers" >&2
    exit 1
  fi
}
trap on_exit EXIT

if [ -n "$STOP_SERVICES" ]; then
  read -ra services <<<"$STOP_SERVICES"
  if ! docker compose -f "$COMPOSE_FILE" stop "${services[@]}"; then
    echo "Error: Failed to stop $APP_NAME containers" >&2
    exit 1
  fi
fi

mkdir -p "$BACKUP_PATH"

if ! rsync -Aax "$DEPLOY_PATH/" "$BACKUP_PATH/"; then
  echo "Error: Failed to sync backup files to $BACKUP_PATH" >&2
  exit 1
fi

echo "Backup script finished."
