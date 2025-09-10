# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Essential commands for daily development:**

```bash
# Run all tests (unit, widget, integration)
make test

# Lint and code analysis  
make lint

# Format code
make format

# Platform-specific development
make dev-ios        # iOS simulator (macOS only)
make dev-android    # Android emulator/device
make dev-web        # Web browser on port 3000

# Build commands
make build-android-apk    # Android APK for testing
make build-android-aab    # Android App Bundle for Play Store
make build-ios           # iOS app bundle (macOS only)
make build-web           # Web application

# Environment setup
make doctor         # Flutter doctor diagnostic
make setup          # Complete environment setup
```

**Code generation (required after model changes):**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Project Architecture

This is a Flutter mobile app for the Living Twin organizational intelligence platform.

**Core Architecture Patterns:**
- **Dependency Injection**: Uses `get_it` + `injectable` (lib/core/di/)
- **State Management**: Provider pattern with mixins
- **API Layer**: Enhanced HTTP client with retry logic (services/api_client_enhanced.dart)
- **Security**: Secure storage, Sentry crash reporting, strict analysis options
- **Offline Support**: SQLite + cache manager for offline capabilities

**Key Directories:**
```
lib/
├── core/                    # Core infrastructure
│   ├── di/                 # Dependency injection setup
│   ├── network/            # HTTP clients and networking
│   ├── cache/              # Cache management
│   ├── security/           # Secure storage
│   ├── error/              # Sentry configuration
│   ├── mixins/             # Reusable behavior (error handling, loading)
│   └── extensions/         # Dart extensions
├── features/               # Feature-based modules
│   ├── auth/              # Authentication screens
│   ├── home/              # Home dashboard
│   ├── chat/              # Chat interface
│   ├── communication/     # Communication features
│   └── onboarding/        # Organization setup
├── models/                # Data models with Freezed
│   └── freezed/           # Generated Freezed models
├── services/              # Business logic services
└── config/                # App configuration
```

**Generated Files (never edit manually):**
- `**/*.g.dart` - JSON serialization
- `**/*.freezed.dart` - Freezed immutable classes  
- `lib/core/di/injection.config.dart` - DI configuration

## Key Technologies

**State Management & Architecture:**
- Provider for state management
- GetIt + Injectable for dependency injection
- Freezed for immutable data models
- Mixins for reusable component behavior

**API Integration:**
- Dio HTTP client with retry logic
- Connects to Living Twin web platform APIs (REST + GraphQL)
- Offline-first architecture with SQLite caching

**Security & Performance:**
- Flutter Secure Storage for sensitive data
- Sentry for crash reporting and error tracking
- Strict Dart analysis options (analysis_options.yaml)
- Hardware-accelerated speech recognition

**Platform Features:**
- Speech-to-text and text-to-speech
- Biometric authentication support
- Push notifications (planned)
- Cross-platform (iOS, Android, Web)

## Development Guidelines

**Code Generation Workflow:**
1. Modify models in `lib/models/freezed/`
2. Run: `flutter pub run build_runner build --delete-conflicting-outputs`
3. Commit both source and generated files

**Testing Strategy:**
- Unit tests: `test/unit/`
- Widget tests: `test/widget/`  
- Integration tests: `integration_test/`
- Run `make test-coverage` for coverage reports

**API Environment Configuration:**
```bash
make connect-local     # http://localhost:8000
make connect-staging   # staging.aprio.one
make connect-prod      # dev.aprio.one
```

**Code Style:**
- Strict linting enabled (analysis_options.yaml)
- Use `make format` before commits
- Prefer final variables and const constructors
- Single quotes for strings
- Avoid print statements (use proper logging)

## Common Tasks

**Adding New Dependencies:**
1. Add to `pubspec.yaml`
2. Run `flutter pub get`
3. If using DI, annotate with `@injectable` or `@singleton`
4. Run build_runner to generate DI config

**Adding New Models:**
1. Create in `lib/models/freezed/` 
2. Use Freezed annotations for immutability
3. Add JSON serialization if needed
4. Run build_runner to generate code

**Platform-Specific Development:**
- iOS: Requires macOS with Xcode 15+
- Android: Requires Android SDK 33+
- Web: Works on all platforms

**Troubleshooting:**
- `make doctor` - Diagnose Flutter issues
- `make clean-all` - Deep clean build artifacts
- Check `analysis_options.yaml` for lint rule explanations