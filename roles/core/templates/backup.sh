#! /usr/bin/env bash
BACKUP_PATH="{{ backup_path }}/core"
export COMPOSE_FILE="{{ core_deploy_path }}/compose.yml"

function backup {
  echo "dumping lldap database"
  docker compose exec -T lldap-db pg_dump >"$BACKUP_PATH/lldap_pg_dump.sql"
}

function restore {
  echo "starting lldap db"
  docker compose up -d lldap-db

  RETRY_COUNT=0
  while ! docker compose exec llda-db pg_isready 2>/dev/null; do
    if [[ $RETRY_COUNT -ge 5 ]]; then
      echo "out of retries exitting"
      exit 1
    fi

    echo "waiting for db to be available"
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
  done

  echo "running database restore"
  docker compose exec -T lldap-db psql <"$BACKUP_PATH/lldap_pg_dump.sql"

  echo "starting server"
  docker compose up -d

  echo "copying data files"
  docker compose cp "$BACKUP_PATH/files" server:/app/core/
}

if [[ $1 == restore ]]; then
  restore
else
  backup
fi
