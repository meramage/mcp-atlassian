#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN="$ROOT/plugin"
DIST="${ROOT}/../meramage-plugins/mcp-atlassian"
MARKET="${ROOT}/../meramage-plugins/.claude-plugin/marketplace.json"

PLUGIN_JSON="$PLUGIN/.claude-plugin/plugin.json"
NEW_VERSION=$(PLUGIN_JSON="$PLUGIN_JSON" python3 - <<'PYEOF'
import json, os, re, sys, tempfile
path = os.environ["PLUGIN_JSON"]
with open(path) as f:
    data = json.load(f)
m = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)", data.get("version", ""))
if not m:
    sys.exit(f"error: unrecognized version format in {path}: {data.get('version')!r}")
data["version"] = f"{m.group(1)}.{m.group(2)}.{int(m.group(3)) + 1}"
dirpath = os.path.dirname(os.path.abspath(path))
tmp_fd, tmp = tempfile.mkstemp(dir=dirpath, suffix=".tmp")
try:
    with os.fdopen(tmp_fd, "w") as f:
        json.dump(data, f, indent=2)
    os.replace(tmp, path)
except Exception:
    os.unlink(tmp)
    raise
print(data["version"])
PYEOF
)
[[ -n "$NEW_VERSION" ]] || { echo "error: version bump produced empty version"; exit 1; }
echo "bumped plugin.json → $NEW_VERSION"

echo "Building plugin..."

rm -rf "$PLUGIN/src"
cp -r "$ROOT/src" "$PLUGIN/"
find "$PLUGIN/src" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "$PLUGIN/src" -name "*.pyc" -delete 2>/dev/null || true

cp "$ROOT/pyproject.toml" "$PLUGIN/"
cp "$ROOT/uv.lock" "$PLUGIN/"

# Patch pyproject.toml for standalone wheel build:
# - replace dynamic version with the bumped static version
# - remove uv-dynamic-versioning from build requirements (causes empty wheels)
PYPROJECT="$PLUGIN/pyproject.toml"
sed -i.bak 's/^dynamic = \["version"\]/version = "'"$NEW_VERSION"'"/' "$PYPROJECT"
sed -i.bak 's|requires = \["hatchling", "uv-dynamic-versioning>=.*"\]|requires = ["hatchling"]|' "$PYPROJECT"
sed -i.bak '/^\[tool\.hatch\.version\]/,/^$/d' "$PYPROJECT"
sed -i.bak '/^\[tool\.uv-dynamic-versioning\]/,/^$/d' "$PYPROJECT"
rm -f "$PYPROJECT.bak"

echo "Done — plugin ready at $PLUGIN"

if [[ -d "$DIST" ]]; then
    rsync -a --delete --exclude=.gitignore "$PLUGIN/" "$DIST/"
    echo "synced → $DIST"
    if [[ -f "$MARKET" ]]; then
        MARKET="$MARKET" NEW_VERSION="$NEW_VERSION" python3 - <<'PYEOF'
import json, os, sys, tempfile
path = os.environ["MARKET"]
new_version = os.environ["NEW_VERSION"]
with open(path) as f:
    data = json.load(f)
plugins = data.get("plugins")
if not isinstance(plugins, list):
    sys.exit(f"error: 'plugins' key missing or not a list in {path}")
found = False
for p in plugins:
    if p.get("name") == "mcp-atlassian":
        p["version"] = new_version
        found = True
        break
if not found:
    sys.exit(f"error: 'mcp-atlassian' not found in {path}")
dirpath = os.path.dirname(os.path.abspath(path))
tmp_fd, tmp = tempfile.mkstemp(dir=dirpath, suffix=".tmp")
try:
    with os.fdopen(tmp_fd, "w") as f:
        json.dump(data, f, indent=2)
    os.replace(tmp, path)
except Exception:
    os.unlink(tmp)
    raise
PYEOF
        echo "bumped marketplace.json → $NEW_VERSION"
    fi
fi
