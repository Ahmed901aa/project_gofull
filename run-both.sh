#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
# GoFull — run the app on the iOS Simulator AND the physical iPhone
# at the same time, with one command.
#
#   ./run-both.sh
#
# Why not `flutter run -d all`: that also launches macOS and Chrome,
# which this app is not built for. So we start one `flutter run` per
# iOS device instead and tag their output.
#
# Each device gets its own process. Hot reload keys (r / R) are NOT
# available here, because two processes cannot share one stdin — use
# VS Code's "GoFull (both devices)" compound if you want hot reload
# on both. Ctrl+C stops both.
# ─────────────────────────────────────────────────────────────────
set -uo pipefail

FLUTTER="${FLUTTER:-$HOME/development/flutter/bin/flutter}"
cd "$(dirname "$0")"

# ── Which devices? ────────────────────────────────────────────
# Read the live device list rather than hardcoding UDIDs, so this keeps
# working after a re-pair or a different simulator.
DEVICES=$("$FLUTTER" devices --machine 2>/dev/null)

PHONE=$(printf '%s' "$DEVICES" | python3 -c '
import json,sys
try: d=json.load(sys.stdin)
except Exception: sys.exit(0)
for x in d:
    if x.get("targetPlatform","").startswith("ios") and not x.get("emulator"):
        print(x["id"]); break')

SIM=$(printf '%s' "$DEVICES" | python3 -c '
import json,sys
try: d=json.load(sys.stdin)
except Exception: sys.exit(0)
for x in d:
    if x.get("targetPlatform","").startswith("ios") and x.get("emulator"):
        print(x["id"]); break')

[[ -z "$PHONE" ]] && echo "⚠ No physical iPhone found — plug it in and unlock it."
[[ -z "$SIM"   ]] && echo "⚠ No booted simulator found — open Simulator first."
if [[ -z "$PHONE" && -z "$SIM" ]]; then
  echo "✗ No iOS devices at all. Nothing to run." >&2
  exit 1
fi

# ── Where is the backend? ─────────────────────────────────────
IP="${SERVER_IP:-$(ipconfig getifaddr en0 2>/dev/null || true)}"
if [[ -z "$IP" ]]; then
  echo "✗ Could not detect a LAN IP. Connect to Wi-Fi or pass SERVER_IP=…" >&2
  exit 1
fi

# `php artisan serve` auto-increments past a busy port, so probe the range.
API_PORT=""
for p in 8000 8001 8002 8003 8004 8005; do
  if curl -s -o /dev/null --max-time 2 "http://$IP:$p/api/app/settings"; then
    API_PORT="$p"; break
  fi
done
if [[ -n "$API_PORT" ]]; then
  echo "✓ Backend reachable at http://$IP:$API_PORT"
else
  API_PORT=8000
  echo "⚠ Backend NOT responding on $IP:8000-8005 — start it with:"
  echo "    cd ~/Desktop/GoFull && composer run dev"
fi

DEFINES=(
  --dart-define=SERVER_IP="$IP"
  --dart-define=SERVER_HOST="$(scutil --get LocalHostName).local"
  --dart-define=API_PORT="$API_PORT"
)

# ── Launch, tagging each device's output ──────────────────────
PIDS=()
launch() {  # launch <label> <device-id>
  local label="$1" id="$2"
  [[ -z "$id" ]] && return
  echo "→ starting on $label ($id)"
  "$FLUTTER" run "${DEFINES[@]}" -d "$id" 2>&1 \
    | sed -u "s/^/[$label] /" &
  PIDS+=($!)
}

# Kill the whole process group on Ctrl+C so no flutter run is orphaned.
cleanup() {
  echo
  echo "→ stopping both devices…"
  for pid in "${PIDS[@]}"; do kill "$pid" 2>/dev/null; done
  pkill -f "flutter_tools.snapshot run" 2>/dev/null
  exit 0
}
trap cleanup INT TERM

launch "simulator" "$SIM"
launch "phone"     "$PHONE"

echo "→ both starting. Ctrl+C stops them."
wait
