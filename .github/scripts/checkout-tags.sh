#!/bin/bash

set -e

GENERATE_SCRIPT="$(dirname "${BASH_SOURCE[0]}")/generate-swagger-ui.sh"

npm install --prefix /tmp/swagger-ui swagger-ui-dist --silent

checkout() {
  local ref="$1"
  local dir="$2"
  echo "Processing $ref -> $dir"
  git -c advice.detachedHead=false clone $GITHUB_SERVER_URL/$GITHUB_REPOSITORY.git --depth 1 --branch "$ref" --quiet "$dir/clone"
  for item in "$dir/clone"/*; do mv "$item" "$dir/"; done
  rm -rf "$dir/clone"
  "$GENERATE_SCRIPT" "$dir"
}

git fetch --all --tags
current_branch=$(git rev-parse --abbrev-ref HEAD)

checkout "$current_branch" HEAD

for tag in $(git tag); do
  checkout "$tag" "$tag"
done
