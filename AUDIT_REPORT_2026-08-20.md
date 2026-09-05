# GoFull Full-Stack Audit & Fix Report — 2026-08-20

Scope: Flutter app (`project_gofull`) + Laravel backend (`~/Desktop/GoFull`).
Method: two exhaustive line-by-line audits (43 findings total), every fix
verified with `dart analyze` (clean), `flutter test` (pass), `php -l`
(clean), live endpoint curls, and DB checks.

---

## 1. The three problems you reported — root causes

### A. App stuck on Splash Screen
| # | Root cause | Where | Status |
|---|---|---|---|
| 1 | `main()` awaited `NotiService().initNotification()` **before** `runApp()`. On a physical iPhone the permission plugin can block; after ~20 s iOS's launch watchdog SIGKILLs the app (seen in dyld crash trace). | `lib/main.dart` | Fixed earlier this session (init moved after `runApp`, `unawaited` + `catchError`) |
| 2 | iOS state restoration assert (SIGABRT in `FlutterAppDelegate … shouldSaveSecureApplicationState`) after reinstall on simulator. | `ios/Runner/AppDelegate.swift` | Fixed (opt-out overrides) |
| 3 | **VS Code F5 ≠ terminal run.** The debugger launches `--start-paused`, then (a) couldn't discover the VM service (macOS Local-Network permission for VS Code; wireless-debug flakiness) leaving the app paused forever, (b) paused on every `SocketException` because the API port had drifted (see C), and (c) passed no `--dart-define`s so the app pointed at 127.0.0.1. | `.vscode/launch.json` | Fixed: `toolArgs` with `SERVER_HOST`/`API_PORT`, `console: terminal`; exception-pause guidance |
| 4 | `devicectl process launch` starts the app in a background-ish state; iOS then kills the debug session ("inactive in background too long" → SIGKILL). Not an app bug — launch by tapping the icon. | tooling | Documented; killing the hung launcher lets `flutter run` attach |
| 5 | Latent: corrupted stored user JSON could throw inside `_onCheckAuth`, emitting no state. | `auth_bloc.dart` | Fixed (try/catch → clearAll → Unauthenticated) |

### B. "Failed" message on provider login (physical phone)
| # | Root cause | Status |
|---|---|---|
| 1 | Backend + account were **always fine** (verified: `POST /auth/login` for 0923663333 succeeds via LAN IP). | n/a |
| 2 | Huawei router **AP isolation** blocked phone↔Mac earlier; now off (phone visible at 192.168.1.197). | Environment fixed |
| 3 | Stale build pointed at dead hotspot IP `172.20.10.5`. | Rebuilt; ServerLocator now self-heals |
| 4 | **API port drift**: a stale `php artisan serve` held :8000 so the real API landed on :8003 — every build (and VS Code runs) got connection-refused. | **Fixed permanently**: `composer.json` dev script pins `--port=8000` |
| 5 | The app collapsed *"cannot reach server"* into the same generic "failed" as *"wrong password"*. | **Fixed**: connection-level `DioException`s now throw `NetworkException` → localized "تعذّر الاتصال…" message (`auth_data_source.dart`, `auth_bloc.dart`, `login_screen.dart`) |
| 6 | iOS Local-Network permission: if denied, iOS blocks ALL LAN traffic (errno 65). | Must tap **Allow**; Settings → GoFull → Local Network |

### C. IP changes break the app
Two-layer fix (done earlier this session, still in force):
- Build time: `run.sh`/`build.sh` inject `SERVER_IP` + `SERVER_HOST` + probed `API_PORT`.
- Runtime: `ServerLocator` probes `UserMacs-MacBook-Air.local` (mDNS) → cached last-good IP → build IP, on startup/resume/connection-error; `ApiClient` re-resolves + retries once; `ReverbService` reconnects on host change.
- New this pass: **banner/document URLs** no longer break on IP change — `Banner.full_image_url` and `ProviderDocument` URLs are built from the **request host** (`url()`) instead of the pinned `APP_URL`.
- Port drift eliminated at the source (pinned :8000).

---

## 2. Backend fixes applied (Laravel)

1. **Status-transition validator was dead code** — read the wrong route param (`request` vs `serviceRequest`), so providers could jump/regress/replay statuses (e.g. resurrect a cancelled order, reset `completed_at`). Fixed param; chain enforced: accepted→en_route→arrived→in_progress→completed; same-status replay = idempotent no-op (`UpdateStatusRequest.php`, `Provider/RequestController.php`).
2. **Ratings overwrote each other** — one shared row per request for both directions. Added `rated_by` ('driver'/'provider'), composite unique, split relations (`rating()` vs `customerRating()`), filtered every aggregate (admin dashboards, provider profile/analytics, driver profile). Migration ran; 63 existing rows backfilled as 'driver'.
3. **Customer PII on public channels** — `orders.fuel_delivery/towing` broadcast name+phone+GPS unauthenticated. Now `PrivateChannel` + authorization (approved providers of that type only). No app impact: nothing subscribed to them.
4. **Suspension didn't revoke tokens** — suspended users kept full API access. `suspend()` now deletes all Sanctum tokens; `activate()` got the same role guard.
5. **Registration bricked** — `ISEND_API_TOKEN` absent → OTP SMS can never send. Dev fallback: outside production, the code is logged (`OtpService`); production still hard-fails. **You must add real `ISEND_*` keys to `.env` before launch.**
6. **Register not transactional** — partial failure left orphan users + burned OTP. Now wrapped in `DB::transaction` with OTP consumed inside.
7. **Password reset was a dead end** — added `POST /api/auth/password/reset` (phone + otp_code + password), revokes all tokens.
8. **Admin login brute-forceable + user-enumerable** — added `throttle:5,1`, unified error message, status checked after credentials.
9. **Zero-priced fuel orders** — order creation now 422s when no active price row exists.
10. **Employee scope bypass** — fuel/towing employees could approve/reject the other type via direct URLs. Enforced in `show/setAppointment/approve/reject` + monitor `show`.
11. **Double-submit race** — two fast taps could create two active orders. `createIfNoActive()` locks the user row in a transaction.
12. **Framework errors now JSON-enveloped** for `api/*` (`{success:false, message, errors?}`) — no more HTML/redirects to mobile clients (`bootstrap/app.php`).
13. **`fcm_token` hidden** from serialized users (leaked to counterpart party before).
14. **Scheduler now runs** (`schedule:work` added to dev stack) — `orders:expire` finally executes; provider-cancel notification no longer promises a re-dispatch that never happens.
15. **Seeder safety** — production seeds reference data only; `start.sh`/`Dockerfile` no longer auto-seed known-password accounts.
16. **Misc**: `REVERB_HOST=127.0.0.1` (was 0.0.0.0 as outbound host), OTP send rejects soft-deleted phones (was wasting paid SMS), lat/lng range validation on location updates, indexes on `service_requests(status / driver_id,status / provider_id,status)`.

## 3. Flutter fixes applied

1. **Fire-and-forget bloc events (9 sites)** — status updates, cancels, and ratings were dispatched into throwaway blocs nobody listened to: failures were invisible (driver sees "task complete", backend still `en_route`) and every call leaked a bloc. New `dispatchTracked()` helper (`lib/core/utils/tracked_dispatch.dart`) + root `ScaffoldMessenger`: failures now surface as snackbars even after navigation, blocs are closed. **"Payment received" now waits for backend confirmation before advancing** (retry stays possible; backend replay is idempotent).
2. **Towing second-"arrived" bug** — at the destination the app re-sent `arrived`, regressing an `in_progress` order. Now only sent on the to-customer leg.
3. **Search-cancel race** — cancelling could still navigate to "driver found" if an in-flight poll landed; back-gesture cancelled the order silently. `_navigated` set first + confirmation dialog on back.
4. **Stuck submit button** — returning from a cancelled search left `_isSubmitting`/`_hasNavigated` true forever (fuel + towing). Reset on return.
5. **Logout never revoked the token server-side** (both apps) — now calls `LogoutUseCase` (POST /auth/logout) + disconnects the Reverb socket.
6. **Availability toggle had no failure path** — driver could look "online" while the backend disagreed. `AvailabilityUpdated`/`ProviderError` handled with resync + snackbar.
7. **Stacked home shells** — three flow screens pushed a *new* `BottomNavShell` (duplicate 5-second `/home` pollers piling up). Now `popUntil(isFirst)`.
8. **"Instance of 'ServerException'" shown to users** — notifications bloc now catches typed exceptions and shows a localized message; exceptions got `toString()` overrides.
9. **Parsing robustness** — `FuelPriceModel` tolerant of wire-type drift (a bad row can't kill the price list); driver trip-details drops hard `as String?` casts; notification date `RangeError` guard; camera screen no longer hangs on denied permissions; polling service is re-entrancy-safe and error-proof.
10. **Corrupted-session guard** in `_onCheckAuth` (see splash causes).
11. **Dependency cleanup** — removed unused `fluttertoast`, `geocoding`, `injectable`, `injectable_generator`, `build_runner`.

## 4. Verification performed

- `dart analyze lib` → **No issues**; `flutter test` → **all pass**; `php -l` on every touched file → clean; `php artisan migrate` → both migrations DONE; `route:list` → 38 API routes OK.
- Live curls via LAN IP: settings ✓, fuel prices ✓, customer login ✓, /home ✓, /driver/requests ✓, 401/404/422 JSON envelopes ✓, password-reset endpoint ✓.
- Backend stack up: serve :8000 (0.0.0.0), Reverb :8080, queue, **scheduler**, vite.
- Provider login `0923663333/12345678` verified server-side via the exact LAN path the phone uses.
- Fresh build installed on iPhone "Ss" (fixed app); DB watcher armed to confirm the phone login.

## 5. Remaining / not fixed (and why)

- **Provider identity documents on the public disk** — needs private-disk move + signed streaming route + migrating existing files; touches admin views. Do before launch.
- **Documentation photos never upload** (towing/fuel evidence) — needs a new backend endpoint + multipart upload; product decision.
- **Hardcoded fallback fuel prices in `fuel_screen.dart`** (0.75/0.85 + name heuristics) — removing them without breaking ordering needs the backend `fuel_type` key used consistently; recommended follow-up.
- **Map-tap selects empty address** in `app_map_widget.dart` (+ legacy Places API endpoints) — needs reverse-geocode wiring.
- Error copy still mixes backend Arabic + English fallbacks in a few screens; suggested: type/code-based mapping.
- `notifications` table lacks `read_at`; push (FCM) collection exists but sending isn't implemented.
- Dead code inventory (offers vertical, changePassword UI, mock trigger button) left in place per "don't remove features" — safe to delete later.

## 6. Running the project from scratch (new machine)

```bash
# Backend
cd ~/Desktop/GoFull
composer install && npm install
cp .env.example .env && php artisan key:generate      # set DB_* + ISEND_*
mysql -u root -e "CREATE DATABASE \`go-full\`"
php artisan migrate --seed                             # dev: seeds test accounts
php artisan storage:link
composer run dev                                       # serve+queue+reverb+scheduler+vite

# Flutter app (server IP auto-detected; phone must be on the same network,
# with AP/client isolation OFF)
cd ~/Desktop/project_Gofull/project_gofull
flutter pub get
./run.sh -d <device-id>        # or F5 in VS Code (launch.json is configured)
```
Test accounts (dev): provider fuel `0923663333`, towing `0923664444`, customer `0911111111`, admin `0910406699` — all `12345678`.
