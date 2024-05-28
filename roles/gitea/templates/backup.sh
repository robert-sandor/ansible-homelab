#! /usr/bin/env bash
BACKUP_PATH="{{ backup_path }}/gitea"
DEPLOY_PATH="{{ gitea_deploy_path }}"
export COMPOSE_FILE="$DEPLOY_PATH/compose.yml"

function backup {
  echo "dumping gitea"
  docker compose exec -it server gitea dump --skip-log --type tar.gz -f - >"$BACKUP_PATH/gitea.tar.gz"
}

function restore {
  mkdir -p "$DEPLOY_PATH/tmp"
  mkdir -p "$DEPLOY_PATH/gitea"

  echo "unarchiving backup"
  tar -xzvf "$BACKUP_PATH/gitea.tar.gz" -C "$DEPLOY_PATH/tmp"

  echo "copying data files and repos"
  cp -vrf "$DEPLOY_PATH"/tmp/data/* "$DEPLOY_PATH/gitea"
  cp -vrf "$DEPLOY_PATH"/tmp/repos/* "$DEPLOY_PATH/gitea/data/gitea-repositories"

  echo "starting containers"
  docker compose up -d

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

  echo "restoring database"
  docker compose exec -T db psql <"$DEPLOY_PATH/tmp/gitea-db.sql"

  echo "regenerating hooks"
  docker compose exec -it server gitea admin regenerate hooks

  echo "removing tmp"
  rm -rf "$DEPLOY_PATH/tmp"
}

if [[ $1 == restore ]]; then
  restore
else
  backup
fi
