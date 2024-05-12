#! /usr/bin/env bash
DEPLOY_PATH="{{ vaultwarden_deploy_path }}"
BACKUP_PATH="{{ backup_path }}/vaultwarden"
export COMPOSE_FILE="$DEPLOY_PATH/compose.yml"

function backup {
  echo "copying data files"
  cp -vr "$DEPLOY_PATH/data" "$BACKUP_PATH/"

  echo "dumping database"
  docker compose exec -T db pg_dump >"$BACKUP_PATH/pg_dump.sql"
}

function restore {
  echo "stating db"
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

  echo "copying data files"
  cp -vr "$BACKUP_PATH/data" "$DEPLOY_PATH/"

  echo "starting server"
  docker compose up -d
}

if [[ $1 == restore ]]; then
  restore
else
  backup
fi
