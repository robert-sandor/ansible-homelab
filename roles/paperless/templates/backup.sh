#! /usr/bin/env bash
BACKUP_PATH="{{ backup_path }}/paperless"
DEPLOY_PATH="{{ paperless_deploy_path }}"
export COMPOSE_FILE="$DEPLOY_PATH/compose.yml"

function backup {
  echo "exporting data"
  docker compose exec server document_exporter ../export
  tar -czvf "$BACKUP_PATH/backup.tar.gz" -C "$DEPLOY_PATH/export" .

  echo "dumping database"
  docker compose exec -T db pg_dump >"$BACKUP_PATH/pg_dump.sql"
}

function restore {
  echo "starting db"
  docker compose up -d db

  RETRY_COUNT=0
  while ! docker compose exec db pg_isready 2>/dev/null; do
    if [[ $RETRY_COUNT -ge 5 ]]; then
      echo "out of retries exitting"
      exit 1
    fi

    echo "waiting for db to be available"
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 2))
  done

  echo "running database restore"
  docker compose exec -T db psql <"$BACKUP_PATH/pg_dump.sql"

  echo "starting other services"
  docker compose up -d

  SLEEP_TIME=60
  echo "waiting for $SLEEP_TIME seconds for paperless to initialize"
  sleep "$SLEEP_TIME"

  echo "copying data files"
  tar -xvzf "$BACKUP_PATH/backup.tar.gz" -C "$DEPLOY_PATH/export"
  docker compose exec server document_importer ../export
}

if [[ $1 == restore ]]; then
  restore
else
  backup
fi
