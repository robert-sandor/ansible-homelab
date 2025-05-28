#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ deploy_path }}"
BACKUP_PATH="{{ backup_path }}"
APP_NAME="{{ app_name }}"
COMPOSE_FILE="$DEPLOY_PATH/$APP_NAME/compose.yml"
STOP_SERVICES="{{ stop_services | default('') }}"
DATABASE_SERVICES="{{ db_services | default('db') }}"

pg_restore() {
  local service="$1"
  local file="$2"

  if ! docker compose -f "$COMPOSE_FILE" up -d "$service"; then
    echo "Error: Failed to start $service container" >&2
    exit 1
  fi

  local retry_count=0
  while ! docker compose -f "$COMPOSE_FILE" exec "$service" pg_isready 2>/dev/null; do
    if [[ $retry_count -ge 5 ]]; then
      echo "out of retries exitting"
      exit 1
    fi

    echo "waiting for db to be available"
    sleep 1
    retry_count=$((retry_count + 1))
  done

  if ! gzip -dc "$file" | docker compose -f "$COMPOSE_FILE" exec -T "$service" psql; then
    echo "Error: Failed to restore database for $service" >&2
    exit 1
  fi
}

if [[ -f "$COMPOSE_FILE" && -n "$STOP_SERVICES" ]]; then
  read -ra services <<<"$STOP_SERVICES"
  if ! docker compose -f "$COMPOSE_FILE" down "${services[@]}"; then
    echo "Error: Failed to stop $APP_NAME containers" >&2
    exit 1
  fi
fi

if ! rsync -ax "$BACKUP_PATH/$APP_NAME" "$DEPLOY_PATH"; then
  echo "Error: Failed to sync backup files to $DEPLOY_PATH" >&2
  exit 1
fi

read -ra db_services <<<"$DATABASE_SERVICES"
for svc in "${db_services[@]}"; do
  pg_restore "$svc" "$DEPLOY_PATH/$APP_NAME/pg_dump/${svc}_pg_dump.sql.gz"
done

if ! docker compose -f "$COMPOSE_FILE" up -d; then
  echo "Error: Failed to start $APP_NAME containers" >&2
  exit 1
fi
