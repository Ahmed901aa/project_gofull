#!/usr/bin/env bash
# Build a release IPA/APK with the server IP baked in.
#   ./build.sh ios          → flutter build ipa
#   ./build.sh apk          → flutter build apk
#   SERVER_IP=1.2.3.4 ./build.sh ios   → override (e.g. a real production host)
set -euo pipefail
FLUTTER="${FLUTTER:-$HOME/development/flutter/bin/flutter}"
TARGET="${1:-ios}"
IP="${SERVER_IP:-$(ipconfig getifaddr en0 2>/dev/null || echo '')}"
[[ -z "$IP" ]] && { echo "✗ No IP detected. Pass SERVER_IP=…" >&2; exit 1; }

# Match run.sh: probe for the actual API port in case artisan serve landed on
# an incremented port. Baked into the release build.
detect_api_port() {
  local p
  for p in 8000 8001 8002 8003 8004 8005; do
    if curl -s -o /dev/null --max-time 2 "http://$IP:$p/api/app/settings"; then
      echo "$p"
      return 0
    fi
  done
  return 1
}
API_PORT="${API_PORT:-$(detect_api_port || echo 8000)}"

echo "→ flutter build $TARGET --dart-define=SERVER_IP=$IP --dart-define=API_PORT=$API_PORT"
exec "$FLUTTER" build "$TARGET" \
  --dart-define=SERVER_IP="$IP" \
  --dart-define=SERVER_HOST="$(scutil --get LocalHostName).local" \
  --dart-define=API_PORT="$API_PORT" \
  "${@:2}"
