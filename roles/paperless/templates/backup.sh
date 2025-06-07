#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ deploy_path }}"
BACKUP_PATH="{{ backup_path }}"
APP_NAME="paperless"
COMPOSE_FILE="$DEPLOY_PATH/$APP_NAME/compose.yml"

if ! docker compose -f "$COMPOSE_FILE" exec server document_exporter --no-progress-bar ../export; then
  echo "Error: Failed to export documents using document_exporter" >&2
  exit 1
fi

if ! rsync -Aax "$DEPLOY_PATH/$APP_NAME" "$BACKUP_PATH"; then
  echo "Error: Failed to sync backup files to $BACKUP_PATH" >&2
  exit 1
fi

echo "Backup script finished."
