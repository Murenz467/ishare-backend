# GitHub Copilot / AI Agent Instructions for iShare Backend

Purpose: Help AI coding agents become productive quickly in this mono-repo (Django backend + Flutter client).

Quickstart (backend)
- Create a Python venv and install deps: `python -m venv .venv && .venv\Scripts\activate` (Windows) or `python3 -m venv .venv && source .venv/bin/activate` (Unix).
- Install: `pip install -r requirements.txt` (see `requirements.txt`).
- Run migrations and dev server: `python manage.py migrate && python manage.py runserver`.
- Run tests: `python manage.py test` (project uses Django test runner; tests live in app `tests.py` files and top-level test files).

Important files & where to look
- Project config: [ishare_project/settings.py](ishare_project/settings.py) — deployment flags (`RAILWAY_ENVIRONMENT`), `DATABASES` via `dj_database_url`, `MEDIA_ROOT` logic, `CORS` and JWT settings.
- Entry point: [manage.py](manage.py)
- Backend API: [api/views.py](api/views.py) (major endpoint implementations and domain logic: registration, booking, trips, payments, subscription).
- Emails helper: [api/emails.py](api/emails.py) — threaded email sending and templates used by views.
- Models/serializers: [api/models.py](api/models.py) and [api/serializers.py](api/serializers.py) — source of truth for shapes and validation.
- Flutter client: [ishare_app/README.md](ishare_app/README.md) and the `ishare_app` folder (mobile/web client). Firebase config: `ishare_app/firebase.json`.
- Static/media: `media/vehicle_photos/` and the `MEDIA_ROOT` logic in settings (Railway vs local).

Big-picture architecture notes
- This is a Django REST backend with multiple apps (notably `api`, `core`, `subscriptions`) and a Flutter client under `ishare_app`.
- Authentication: JWT via `djangorestframework_simplejwt`. The backend supports login by email or username via `CustomTokenObtainPairView` in `api/views.py`.
- Data flow: Flutter client calls REST endpoints; protected endpoints require `Authorization: Bearer <token>` header. Many viewsets rely on `serializer.save(context={'request': request})` to include absolute media URLs.
- Business logic lives in viewsets (see `api/views.py`) rather than service objects; changes should preserve serializer context and existing DB-side invariants (e.g., seat deduction on booking).

Project-specific conventions & patterns
- Always pass `context={'request': request}` to serializers when returning objects with file fields so URLs are absolute (common in `UserProfileViewSet.me` and booking responses).
- Query optimization: code frequently uses `select_related()` to reduce queries (follow existing patterns in `get_queryset()` methods).
- Use DRF `@action` for custom endpoints on viewsets (examples in `BookingViewSet`, `TripViewSet`).
- Subscription checks are enforced in endpoints (e.g., trip creation and booking flows call `Subscription.objects.get_or_create` and validate `is_active()` before permitting actions).
- Emails are sent via helper functions in `api/emails.py` using background threads — prefer calling those helpers rather than raw `send_mail` everywhere.

Integration points & external deps to be aware of
- Database: `dj_database_url` — production relies on `DATABASE_URL` env var; fallback is sqlite `db.sqlite3`.
- Email: SMTP configured in `settings.py` (look at `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD`), and `api/emails.py` provides threaded helpers.
- Twilio is in `requirements.txt` but not heavily used in code; verify before modifying phone/SMS flows.
- Payments are currently simulated in `api/views.py` (no external payment gateway). Subscription/payment logic is intentionally simple and can be replaced by real gateways.
- Deployment notes: `RAILWAY_ENVIRONMENT` presence toggles production behavior (media path, SECURE_PROXY_SSL_HEADER). See `ishare_project/settings.py`.

Debugging & developer workflows
- Local dev: run `python manage.py runserver` and hit endpoints from the Flutter client or use `httpie`/`curl`.
- To test auth quickly: POST to token endpoint (note: backend accepts email as login, it maps to username before creating token):

  - Example:
    curl -X POST http://127.0.0.1:8000/api/token/ -d "username=you@example.com&password=yourpass"

- Running the Flutter client: use the scripts in `ishare_app` (e.g., `run_flutter.bat` / `run_flutter.ps1`) or open the Flutter project in VS Code/Android Studio.
- VS Code task: workspace contains a task `build` that runs `dotnet build` (used for Windows/Flutter desktop builds). Check the VS Code tasks panel if needed.

When editing code
- Preserve serializer contexts and `select_related` optimizations.
- Keep business logic idempotent (e.g., updating `trip.available_seats` in `perform_create` for `BookingViewSet` is a critical operation — test edge cases such as concurrent bookings).
- If adding new endpoints, follow existing patterns: DRF viewsets, use `parser_classes=[MultiPartParser, FormParser, JSONParser]` when file uploads are expected.

Examples to reference
- Auth behavior: `CustomTokenObtainPairView` in [api/views.py](api/views.py) — accepts email or username.
- Booking flow: `BookingViewSet.perform_create` updates `trip.available_seats` and sends `send_booking_confirmation()` from [api/emails.py](api/emails.py).
- Settings toggles: `MEDIA_ROOT`/`CORS_ALLOW_ALL_ORIGINS` are set in [ishare_project/settings.py](ishare_project/settings.py).

What not to change without caution
- `MEDIA_ROOT` behavior and `CORS` config — these were adjusted for Railway deployment and for Flutter Web; changing them may break uploads or cross-origin requests.
- Token/auth logic — several areas assume JWT and the `CustomTokenObtainPairView` mapping from email to username.
- Seat accounting in `BookingViewSet` — concurrency and correctness are important; add tests for any change here.

If you need more context
- Ask to inspect specific files (models, serializers, or tests) and I will extract exact shapes and examples to include.

— End of instructions. Please tell me which areas to expand (e.g., deeper model docs, example API payloads, or CI/deployment steps).