#! /usr/bin/env bash
set -eou pipefail

HOSTNAME=$(hostname)
RESTIC_PATH="{{ restic_deploy_path }}"
BACKUP_PATH="{{ backup_path }}"

RESTIC="docker run --rm --hostname $HOSTNAME -v $RESTIC_PATH/secrets:/run/secrets -v $BACKUP_PATH:/backup restic/restic"

$RESTIC --repository-file /run/secrets/restic-repo --password-file /run/secrets/restic-password ls latest

if [[ $1 == restore ]]; then

elif [[ $1 == prune ]]; then

else
  docker run --rm \
    --hostname {{ ansible_fqdn }} \
    -v {{ restic_deploy_path }}/secrets:/run/secrets \
    -v {{ backup_path }}:/backup \
    restic/restic:{{ restic_version }} \
    backup /backup
fi
