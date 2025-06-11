#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ deploy_path }}"
BACKUP_PATH="{{ backup_path }}"
APP_NAME="{{ util_app }}"
COMPOSE_FILE="$DEPLOY_PATH/$APP_NAME/compose.yml"
STOP_SERVICES="{{ util_stop_services | default('') }}"

on_exit() {
  if ! docker compose -f "$COMPOSE_FILE" up -d; then
    echo "Error: Failed to restart $APP_NAME containers" >&2
    exit 1
  fi
}
trap on_exit EXIT

if [ -n "$STOP_SERVICES" ]; then
  read -ra services <<<"$STOP_SERVICES"
  if ! docker compose -f "$COMPOSE_FILE" down "${services[@]}"; then
    echo "Error: Failed to stop $APP_NAME containers" >&2
    exit 1
  fi
fi

if ! rsync -Aax "$DEPLOY_PATH/$APP_NAME" "$BACKUP_PATH"; then
  echo "Error: Failed to sync backup files to $BACKUP_PATH" >&2
  exit 1
fi

echo "Backup script finished."
