#!/usr/bin/env sh
set -e

# Ensure more expensive operations are run (mimetypes, etc.)
./occ maintenance:repair --include-expensive

# Ensure missing indices are created
./occ db:add-missing-indices
