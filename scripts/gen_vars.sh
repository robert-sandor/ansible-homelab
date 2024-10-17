#!/usr/bin/env bash

set -euxo pipefail

PROJECT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)
echo "---" >"$PROJECT_DIR"/inventory/defaults.yml
cat "$PROJECT_DIR"/roles/*/defaults/main/user.yml | sed '/---/d' >>"$PROJECT_DIR"/inventory/group_vars/all.yml.sample
