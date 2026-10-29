#!/bin/sh
set -eu

case "${OPENCLAW_BUNDLED_PLUGIN_PATH:-}" in
  dist/extensions/*) ;;
  *) echo "invalid bundled plugin path" >&2; exit 1 ;;
esac

plugin_root="$OPENCLAW_GATEWAY_PACKAGE/lib/openclaw/$OPENCLAW_BUNDLED_PLUGIN_PATH"
manifest="$plugin_root/openclaw.plugin.json"
if [ ! -d "$plugin_root" ] || [ ! -f "$manifest" ]; then
  echo "bundled plugin root is missing" >&2
  exit 1
fi
if [ "$(jq -r '.id // empty' "$manifest")" != "$OPENCLAW_BUNDLED_PLUGIN_ID" ]; then
  echo "bundled plugin manifest id mismatch" >&2
  exit 1
fi

mkdir -p "$out/node_modules"
cp -R "$plugin_root/." "$out/"
ln -s "$OPENCLAW_GATEWAY_PACKAGE/lib/openclaw" "$out/node_modules/openclaw"
