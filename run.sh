#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
# GoFull — run the Flutter app with the server IP auto-detected.
#
# The app reads SERVER_IP via --dart-define (see lib/core/network/app_config.dart),
# so changing Wi‑Fi never requires editing code. Just re-run this script.
#
#   ./run.sh                          # auto-detect IP, prompt for device
#   ./run.sh -d <deviceId>            # extra args go straight to `flutter run`
#   SERVER_IP=10.0.2.2 ./run.sh       # override (e.g. Android emulator)
#   ./run.sh --release                # release build to a device
# ─────────────────────────────────────────────────────────────────
set -euo pipefail

FLUTTER="${FLUTTER:-$HOME/development/flutter/bin/flutter}"

detect_ip() {
  # Try Wi‑Fi first, then any active interface with an IPv4 address.
  local ip
  ip=$(ipconfig getifaddr en0 2>/dev/null || true)
  if [[ -z "$ip" ]]; then
    for iface in $(ifconfig -l); do
      ip=$(ipconfig getifaddr "$iface" 2>/dev/null || true)
      [[ -n "$ip" && "$ip" != 127.* ]] && break
      ip=""
    done
  fi
  echo "$ip"
}

IP="${SERVER_IP:-$(detect_ip)}"
if [[ -z "$IP" ]]; then
  echo "✗ Could not detect a LAN IP. Connect to Wi‑Fi or pass SERVER_IP=…" >&2
  exit 1
fi

# `php artisan serve` auto-increments past a busy port, so the API may be on
# 8001/8002/etc. rather than the default. Probe the usual range and use the
# first port that answers /api/app/settings.
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

API_PORT="${API_PORT:-$(detect_api_port || echo '')}"
if [[ -n "$API_PORT" ]]; then
  echo "✓ Backend reachable at http://$IP:$API_PORT"
else
  API_PORT=8000
  echo "⚠ Backend NOT responding on $IP:8000-8005 — start it with:"
  echo "    cd /Users/usermac/Desktop/GoFull && npm run dev"
fi

echo "→ flutter run --dart-define=SERVER_IP=$IP --dart-define=API_PORT=$API_PORT $*"
exec "$FLUTTER" run \
  --dart-define=SERVER_IP="$IP" \
  --dart-define=SERVER_HOST="$(scutil --get LocalHostName).local" \
  --dart-define=API_PORT="$API_PORT" \
  "$@"
