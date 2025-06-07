#!/usr/bin/env sh
set -e

maintenance_window_start="{{ nextcloud_maintenance_window_start }}"
./occ config:system:set maintenance_window_start --type=integer --value="$maintenance_window_start"
