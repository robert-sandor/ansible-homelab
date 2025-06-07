#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ deploy_path }}"
BACKUP_PATH="{{ backup_path }}"
APP_NAME="{{ common_app_name }}"
COMPOSE_FILE="$DEPLOY_PATH/$APP_NAME/compose.yml"
STOP_SERVICES="{{ common_stop_services | default('') }}"

if [[ -f "$COMPOSE_FILE" && -n "$STOP_SERVICES" ]]; then
  read -ra services <<<"$STOP_SERVICES"
  if ! docker compose -f "$COMPOSE_FILE" down "${services[@]}"; then
    echo "Error: Failed to stop $APP_NAME containers" >&2
    exit 1
  fi
fi

if ! rsync -Aax "$BACKUP_PATH/$APP_NAME" "$DEPLOY_PATH"; then
  echo "Error: Failed to sync backup files to $DEPLOY_PATH" >&2
  exit 1
fi

if ! docker compose -f "$COMPOSE_FILE" up -d; then
  echo "Error: Failed to start $APP_NAME containers" >&2
  exit 1
fi
