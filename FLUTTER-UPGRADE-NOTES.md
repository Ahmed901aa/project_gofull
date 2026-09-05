# GoFull Flutter Upgrade — 2026-08-06

Matches the backend changes (OTP registration, Reverb realtime). No new pub dependencies were added.

## 1. OTP registration flow

Register now runs in two steps: tap register → `POST /auth/otp/send` → bottom sheet with 6 code boxes (auto-confirms when full, resend with 60s timer) → `POST /auth/register` with `otp_code`.

New/changed:

- `core/network/api_constants.dart` — `otpSend`, `otpVerify`, `broadcastingAuth`
- `auth/domain/usecases/send_otp_usecase.dart` (new)
- `auth/presentation/widgets/register_otp_sheet.dart` (new, reuses profile's `OtpInputBox`/`OtpResendTimer`; `OtpInputBox` gained a `width` param for 6 boxes)
- `AuthDataSource`/`Repository`/`RegisterUseCase`/`AuthBloc` — `sendOtp` + `otpCode` threaded through; new states `OtpSending`/`OtpSent`
- `register_screen.dart` — listener opens the sheet on `OtpSent`, guarded against double-open on resend

Server error messages (already localized Arabic from the API) are shown as-is.

## 2. Realtime over Reverb (WebSocket)

`core/services/reverb_service.dart` (new) — minimal Pusher-protocol client on `dart:io` `WebSocket`: connection, private-channel auth via `POST /broadcasting/auth` (Bearer token via existing Dio interceptor), ping/pong, auto-resubscribe, exponential-backoff reconnect (2→30s). Registered in GetIt.

Config in `core/network/app_config.dart` — `reverbHost`, `reverbPort` (8080), `reverbAppKey` (`go-full-key`), `reverbUseTls`. **Must match the Laravel `.env`** (change host together with `baseUrl`; for Railway set TLS true + port 443 or your Reverb ingress).

**Customer trip screen** (`trip_in_progress_screen.dart`): subscribes to `private-driver.{userId}`; `order.status.updated`/`order.cancelled` trigger an instant refresh; `provider.location.updated` updates the live remaining distance (provider → destination). Polling reduced from 3s to a 15s fallback.

**Provider navigation** (`navigate_location_mixin.dart`): the fixed 10s GPS timer is replaced with `Geolocator.getPositionStream(distanceFilter: 20 m)` + a 45s stationary keepalive — much less battery/API load. Errors are now logged instead of swallowed.

## 3. Review fixes applied

Swallowed errors now logged (`gps_utils.dart`, location mixin), `StreamSubscription` cancelled in `disposeLocation()`, OTP sheet timers/mounted guards correct.

## Known issues NOT yet fixed (from review)

1. `app_map_widget.dart:162, 238` — empty `catch (_) {}` blocks still swallow errors.
2. `home_screen.dart` + `driver_home_screen.dart` — 5s polling timers remain; both could move to Reverb channels the same way as the trip screen.
3. Provider registration (role `provider` with vehicle + documents upload) has no UI — the register screen hardcodes `role: 'driver'`; the backend requires FormData with documents for providers.
4. `trip_in_progress_screen.dart` still calls `context.read<AppConfigBloc>()` inside `build` (works, but a `BlocBuilder` scoped to the payment section would be cleaner).
5. No offline queue for request creation — declined scope this round; a Dio retry interceptor + connectivity check is the next-best improvement for Libyan network conditions.

## Testing checklist

1. Backend: `php artisan migrate`, Reverb running (`php artisan reverb:start`), queue worker running.
2. Register a new account → SMS arrives via iSend → wrong code shows Arabic error, correct code logs in.
3. As provider, accept an order and drive — the customer's trip screen distance updates without waiting for the 15s poll.
4. Kill Reverb mid-trip — app falls back to polling; restart Reverb — reconnects within 30s.
