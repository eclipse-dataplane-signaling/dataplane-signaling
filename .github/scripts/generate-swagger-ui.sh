#!/bin/bash
# Usage: generate-swagger-ui.sh <version-dir>

set -e

VERSION_DIR="$1"
SWAGGER_DIST="/tmp/swagger-ui/node_modules/swagger-ui-dist"

YAML_FILES=(
  "control-plane"
  "data-plane"
)

mkdir -p "$VERSION_DIR/_swagger-assets"
cp "$SWAGGER_DIST/swagger-ui-bundle.js" "$VERSION_DIR/_swagger-assets/"
cp "$SWAGGER_DIST/swagger-ui.css" "$VERSION_DIR/_swagger-assets/"

for YAML_NAME in "${YAML_FILES[@]}"; do
  if [ ! -f "$VERSION_DIR/signaling-$YAML_NAME-openapi.yaml" ]; then
    echo "$YAML_NAME.yaml not found in $VERSION_DIR"
    exit 1
  fi

  TITLE=$(echo "$YAML_NAME" | tr '-' ' ')
  output_dir="$VERSION_DIR/api/$YAML_NAME"
  mkdir -p "$output_dir"

  YAML_NAME="$YAML_NAME" TITLE="$TITLE" envsubst '$YAML_NAME $TITLE' \
    < "$(dirname "${BASH_SOURCE[0]}")/swagger-ui-template.html" \
    > "$output_dir/index.html"

  echo "Generated swagger-ui page for $YAML_NAME in $VERSION_DIR"
done
