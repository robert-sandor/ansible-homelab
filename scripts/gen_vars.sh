#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 [-a|--advanced] [-o output.yml] [role1 role2 ...]"
  echo "  -a, --advanced   Include advanced settings"
  echo "  -o FILE          Output to FILE instead of stdout"
  exit 1
}

INCLUDE_ADVANCED=false
OUTPUT_FILE=""
ROLES=()

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--advanced)
      INCLUDE_ADVANCED=true
      shift
      ;;
    -o)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -*)
      usage
      ;;
    *)
      ROLES+=("$1")
      shift
      ;;
  esac
done

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROLES_DIR="$PROJECT_DIR/roles"

if [[ ${#ROLES[@]} -eq 0 ]]; then
  # All roles (portable version)
  ROLES=()
  for d in "$ROLES_DIR"/*; do
    [ -d "$d" ] && ROLES+=("$(basename "$d")")
  done
fi

{
  echo "---"
  for role in "${ROLES[@]}"; do
    DEFAULTS_FILE="$ROLES_DIR/$role/defaults/main.yml"
    if [[ -f "$DEFAULTS_FILE" ]]; then
      if $INCLUDE_ADVANCED; then
        # Skip first line if it's '---'
        tail -n +2 "$DEFAULTS_FILE" | awk 'NR==1 && $0 ~ /^---$/ {next} {print}'
      else
        # Print up to (but not including) the advanced settings comment, skipping first line if it's '---'
        awk 'NR==1 && $0 ~ /^---$/ {next} /^### Advanced settings/ {exit} {print}' "$DEFAULTS_FILE"
      fi
    else
      echo "# Skipping $role: no defaults/main.yml found" >&2
    fi
  done
} | if [[ -n "$OUTPUT_FILE" ]]; then tee "$OUTPUT_FILE"; else cat; fi
