#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ util_deploy_path }}"
BACKUP_PATH="{{ util_backup_path }}"
APP_NAME="{{ util_app }}"
COMPOSE_FILE="$DEPLOY_PATH/compose.yml"
STOP_SERVICES="{{ util_stop_services }}"

if [[ -f "$COMPOSE_FILE" && -n "$STOP_SERVICES" ]]; then
  read -ra services <<<"$STOP_SERVICES"
  if ! docker compose -f "$COMPOSE_FILE" down "${services[@]}"; then
    echo "Error: Failed to stop $APP_NAME containers" >&2
    exit 1
  fi
fi

mkdir -p "$DEPLOY_PATH"

if ! rsync -Aax "$BACKUP_PATH/" "$DEPLOY_PATH/"; then
  echo "Error: Failed to sync backup files to $DEPLOY_PATH" >&2
  exit 1
fi

if ! docker compose -f "$COMPOSE_FILE" up -d; then
  echo "Error: Failed to start $APP_NAME containers" >&2
  exit 1
fi
