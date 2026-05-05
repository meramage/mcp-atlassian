#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PLUGIN="$ROOT/plugin"

echo "Building plugin..."

rm -rf "$PLUGIN/src"
cp -r "$ROOT/src" "$PLUGIN/"
find "$PLUGIN/src" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "$PLUGIN/src" -name "*.pyc" -delete 2>/dev/null || true

cp "$ROOT/pyproject.toml" "$PLUGIN/"
cp "$ROOT/uv.lock" "$PLUGIN/"

# Patch pyproject.toml for standalone wheel build:
# - replace dynamic version with static "0.1.0"
# - remove uv-dynamic-versioning from build requirements (causes empty wheels)
VERSION="0.1.0"
PYPROJECT="$PLUGIN/pyproject.toml"
sed -i 's/^dynamic = \["version"\]/version = "'"$VERSION"'"/' "$PYPROJECT"
sed -i 's|requires = \["hatchling", "uv-dynamic-versioning>=.*"\]|requires = ["hatchling"]|' "$PYPROJECT"
sed -i '/^\[tool\.hatch\.version\]/,/^$/d' "$PYPROJECT"
sed -i '/^\[tool\.uv-dynamic-versioning\]/,/^$/d' "$PYPROJECT"

echo "Done — plugin ready at $PLUGIN"
