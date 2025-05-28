#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ deploy_path }}"
BACKUP_PATH="{{ backup_path }}"
APP_NAME="paperless"
COMPOSE_FILE="$DEPLOY_PATH/$APP_NAME/compose.yml"

if ! rsync -ax "$DEPLOY_PATH/$APP_NAME" "$BACKUP_PATH"; then
  echo "Error: Failed to sync backup files to $BACKUP_PATH" >&2
  exit 1
fi

if ! docker compose -f "$COMPOSE_FILE" up -d; then
  echo "Error: Failed to start $APP_NAME containers" >&2
  exit 1
fi

if ! docker compose -f "$COMPOSE_FILE" exec server document_importer --no-progress-bar ../export; then
  echo "Error: Failed to export documents using document_exporter" >&2
  exit 1
fi
