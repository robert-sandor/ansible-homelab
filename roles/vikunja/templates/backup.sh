#! /usr/bin/env bash
BACKUP_PATH="{{ backup_path }}/vikunja"
export COMPOSE_FILE="{{ vikunja_deploy_path }}/compose.yml"

function backup {
  echo "copying files"
  docker compose cp server:/app/vikunja/files "$BACKUP_PATH/"

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
    RETRY_COUNT=$((RETRY_COUNT + 1))
  done

  echo "running database restore"
  docker compose exec -T db psql <"$BACKUP_PATH/pg_dump.sql"

  echo "starting server"
  docker compose up -d

  echo "copying data files"
  docker compose cp "$BACKUP_PATH/files" server:/app/vikunja/
}

if [[ $1 == restore ]]; then
  restore
else
  backup
fi
