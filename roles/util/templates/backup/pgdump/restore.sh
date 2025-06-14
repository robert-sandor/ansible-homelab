#!/usr/bin/env bash

set -euo pipefail

DEPLOY_PATH="{{ util_deploy_path }}"
BACKUP_PATH="{{ util_backup_path }}"
APP_NAME="{{ util_app }}"
COMPOSE_FILE="$DEPLOY_PATH/compose.yml"
STOP_SERVICES="{{ util_stop_services | default('') }}"
DATABASE_SERVICES="{{ util_db_services | default('db') }}"

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

mkdir -p "$DEPLOY_PATH"

if ! rsync -Aax "$BACKUP_PATH/" "$DEPLOY_PATH/"; then
  echo "Error: Failed to sync backup files to $DEPLOY_PATH" >&2
  exit 1
fi

read -ra db_services <<<"$DATABASE_SERVICES"
for svc in "${db_services[@]}"; do
  pg_restore "$svc" "$DEPLOY_PATH/pg_dump/${svc}_pg_dump.sql.gz"
done

if ! docker compose -f "$COMPOSE_FILE" up -d; then
  echo "Error: Failed to start $APP_NAME containers" >&2
  exit 1
fi
