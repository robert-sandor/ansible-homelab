#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ deploy_path }}"
BACKUP_PATH="{{ backup_path }}"
APP_NAME="{{ common_app_name }}"
COMPOSE_FILE="$DEPLOY_PATH/$APP_NAME/compose.yml"
STOP_SERVICES="{{ common_stop_services | default('') }}"
DATABASE_SERVICES="{{ common_db_services | default('db') }}"

pg_dump() {
  local service="$1"
  local file="$2"

  mkdir -p "$(dirname "$file")"

  if ! docker compose -f "$COMPOSE_FILE" exec -T "$service" pg_dumpall -c | gzip >"$file"; then
    echo "Error: Failed to dump database for $service" >&2
    exit 1
  fi

  echo "Database dump for $service completed successfully."
}

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

read -ra db_services <<<"$DATABASE_SERVICES"
for svc in "${db_services[@]}"; do
  pg_dump "$svc" "$DEPLOY_PATH/$APP_NAME/pg_dump/${svc}_pg_dump.sql.gz"
done

if ! rsync -Aax "$DEPLOY_PATH/$APP_NAME" "$BACKUP_PATH"; then
  echo "Error: Failed to sync backup files to $BACKUP_PATH" >&2
  exit 1
fi

echo "Backup script finished."
