#!/usr/bin/env bash
set -euo pipefail

BACKUP_PATH="{{ backup_path }}"
DEPLOY_PATH="{{ deploy_path }}"
export COMPOSE_FILE="$DEPLOY_PATH/vaultwarden/compose.yml"

function backup {
  echo "stop vaultwarden"
  docker compose stop server

  echo "sync files to backup"
  rsync -a "$DEPLOY_PATH/vaultwarden" "$BACKUP_PATH"

  echo "dumping database"
  docker compose exec -T db pg_dump >"$BACKUP_PATH/pg_dump.sql"

  echo "start vaultwarden"
  docker compose up -d
}

function restore {
  echo "ensure server is not running"
  [ -f "$COMPOSE_FILE" ] && docker compose down server

  echo "sync files to deploy path"
  rsync -a "$BACKUP_PATH/vaultwarden" "$DEPLOY_PATH"

  echo "start db container"
  docker compose up -d db

  RETRY_COUNT=0
  while ! docker compose exec db pg_isready 2>/dev/null; do
    if [[ $RETRY_COUNT -ge 5 ]]; then
      echo "out of retries exitting"
      exit 1
    fi

    echo "waiting for db to be available"
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
  done

  echo "running database restore"
  docker compose exec -T db psql <"$BACKUP_PATH/pg_dump.sql"

  echo "starting server"
  docker compose up -d
}

if [[ ${1:-backup} == restore ]]; then
  restore
else
  backup
fi
