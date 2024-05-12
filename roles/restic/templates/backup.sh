#! /usr/bin/env bash
set -eou pipefail

HOSTNAME=$(hostname)
RESTIC_PATH="{{ restic_deploy_path }}"
BACKUP_PATH="{{ backup_path }}"

RESTIC="docker run --rm --hostname $HOSTNAME -v $RESTIC_PATH/secrets:/run/secrets -v $BACKUP_PATH:/backup restic/restic"

$RESTIC --repository-file /run/secrets/restic-repo --password-file /run/secrets/restic-password ls latest
