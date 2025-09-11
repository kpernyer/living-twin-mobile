# Living Twin Mobile - Flutter/Dart Application

Cross-platform mobile application for **Living Twin** — the organizational intelligence platform. Built with Flutter/Dart, consuming the same REST and GraphQL APIs as the web application.

## 📱 Platform Support

- ✅ **iOS** - iPhone and iPad
- ✅ **Android** - Phones and tablets  
- ✅ **Web** - Browser-based mobile experience
- 🚧 **macOS** - Desktop app (future)
- 🚧 **Windows** - Desktop app (future)
- 🚧 **Linux** - Desktop app (future)

## 🚀 Quick Start

```bash
# Install Flutter and dependencies
make install

# Setup development environment
make setup

# Start development
make dev

# Platform-specific development
make dev-ios        # iOS simulator
make dev-android    # Android emulator
make dev-web        # Web browser (port 3000)
```

## 📖 Architecture

```bash
┌─────────────────────────────────────────────┐
│             Flutter Mobile App             │
│                                             │
│  ┌─────────────┐  ┌─────────────┐          │
│  │     iOS     │  │   Android   │          │
│  │ (Objective-C│  │   (Kotlin   │          │
│  │  + Swift)   │  │   + Java)   │          │
│  └─────────────┘  └─────────────┘          │
│                                             │
│  ┌─────────────────────────────────────────┐ │
│  │         Flutter Framework (Dart)        │ │
│  └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
                      │
                      │ REST + GraphQL
                      ▼
┌─────────────────────────────────────────────┐
│          Living Twin Web Platform          │
│                                             │
│  API (FastAPI + Strawberry GraphQL)        │
│  • http://localhost:8000/docs               │
│  • http://localhost:8000/graphql            │
│                                             │
│  Knowledge Graph (Neo4j)                   │
│  Cache Layer (Redis)                       │
└─────────────────────────────────────────────┘
```

## 🛠️ Development Environment

### Prerequisites

**macOS (for iOS development):**
- Xcode 15+
- Xcode Command Line Tools
- CocoaPods
- iOS Simulator

**All Platforms (for Android development):**
- Android Studio
- Android SDK 33+
- Android Emulator or physical device

**Docker (optional):**
- Docker Desktop
- For containerized development and CI/CD

### Setup Commands

```bash
# Complete environment setup
make setup                 # All platforms
make setup-ios             # iOS tools (macOS only)
make setup-android         # Android tools
make setup-web             # Web development

# Health check
make doctor                # Flutter doctor diagnostic
```

## 📱 Development Workflow

### Native Development (Recommended)

```bash
# iOS Development (macOS only)
make dev-ios              # Start on iOS simulator
make build-ios            # Build iOS app bundle

# Android Development
make dev-android          # Start on Android device/emulator  
make build-android-apk    # Build APK for testing
make build-android-aab    # Build App Bundle for Play Store

# Web Development
make dev-web              # Start web server on port 3000
make build-web            # Build web application
```

### Docker Development (Cross-platform)

```bash
# Build Flutter development container
make docker-build

# Run development in container
make docker-dev           # Web development in container
make docker-test          # Run tests in container
make docker-build-web     # Build web app in container
```

## 🔗 API Integration

The mobile app connects to the same backend as the web application:

```bash
# Connect to local development API
make connect-local        # http://localhost:8000

# Connect to staging environment  
make connect-staging      # https://staging.aprio.one/api

# Connect to production
make connect-prod         # https://dev.aprio.one/api
```

### API Endpoints Used

- **REST API**: Complete CRUD operations
- **GraphQL API**: Strategic intelligence queries
- **WebSocket**: Real-time updates (future)
- **Authentication**: Firebase Auth integration

## 🧪 Testing

```bash
# Run all tests
make test

# Test types
make test-unit            # Unit tests
make test-widget          # Widget tests  
make test-integration     # End-to-end tests
make test-coverage        # Generate coverage report

# Code quality
make lint                 # Dart analyzer
make format               # Format Dart code
```

## 🏗️ Build & Release

### Development Builds

```bash
# Quick builds for testing
make build-android-apk    # Android APK
make build-ios            # iOS app (macOS only)
make build-web            # Web application
make build-all            # All available platforms
```

### Release Builds

```bash
# Android App Bundle for Play Store
flutter build appbundle --release

# iOS Archive for App Store (macOS only)
flutter build ipa --release

# Web build for production
flutter build web --release
```

## 📁 Project Structure

```
living-twin-mobile/
├── lib/                    # Dart source code
│   ├── main.dart          # App entry point
│   ├── screens/           # UI screens
│   ├── widgets/           # Reusable UI components
│   ├── services/          # API integration
│   ├── models/            # Data models
│   ├── providers/         # State management
│   └── utils/             # Helper functions
├── test/                  # Test files
│   ├── unit/             # Unit tests
│   ├── widget/           # Widget tests
│   └── integration/      # Integration tests
├── integration_test/     # End-to-end tests
├── android/              # Android-specific code
├── ios/                  # iOS-specific code
├── web/                  # Web-specific code
├── docker/               # Docker configuration
├── docs/                 # Documentation
├── tools/                # Development tools
├── pubspec.yaml          # Dependencies
└── Makefile             # Development commands
```

## 🎯 Key Features

- **Organizational Intelligence**: Strategic AI insights on mobile
- **Offline Capabilities**: Core features work without internet
- **Push Notifications**: Real-time organizational alerts
- **Biometric Authentication**: Face ID, Touch ID, Fingerprint
- **Dark Mode Support**: Follows system preferences
- **Accessibility**: Screen reader and voice control support
- **Multi-language**: Internationalization ready

## 📚 Documentation

- **[Flutter Development Guide](docs/flutter-react-comparison.md)**
- **[API Integration](docs/readme.md)**
- **[Security & Performance](docs/dart_security_performance_audit.md)**
- **[Crash Reporting](docs/crash_reporting_setup.md)**
- **[Dependency Injection](docs/dependency_injection_example.md)**
- **[Migration Guide](docs/dart_migration_guide.md)**
- **[Optimization Guide](docs/dart_optimization_status.md)**

## 🚀 CI/CD & Deployment

### GitHub Actions (Recommended)

```yaml
# .github/workflows/mobile.yml
name: Mobile CI/CD
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: make test
  
  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: make build-android-aab
      
  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: make build-ios
```

### Manual Deployment

```bash
# Android Play Store
make build-android-aab
# Upload to Google Play Console

# iOS App Store (macOS only)
make build-ios
# Upload via Xcode or App Store Connect
```

## 🔧 Development Tips

### Hot Reload
```bash
# While app is running, press:
# r - Hot reload
# R - Hot restart
# q - Quit

# Or use Makefile shortcuts
make hot-reload
make hot-restart
```

### Debugging
```bash
# Flutter Inspector
flutter inspector

# Debug mode
flutter run --debug

# Profile mode (performance testing)
flutter run --profile

# Release mode (production testing)
flutter run --release
```

### Platform-Specific Code
```dart
// Example: Platform-specific implementations
import 'dart:io' show Platform;

if (Platform.isIOS) {
  // iOS-specific code
} else if (Platform.isAndroid) {
  // Android-specific code
} else if (kIsWeb) {
  // Web-specific code
}
```

## 🤝 Contributing

1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/amazing-feature`
3. **Follow code standards**: `make lint && make format`
4. **Add tests**: `make test`
5. **Commit changes**: `git commit -m 'Add amazing feature'`
6. **Push to branch**: `git push origin feature/amazing-feature`
7. **Open Pull Request**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**Flutter Doctor Issues:**
```bash
make doctor                # Diagnose issues
flutter doctor --android-licenses    # Accept Android licenses
```

**iOS Build Issues (macOS):**
```bash
cd ios && pod install     # Update CocoaPods
cd ios && pod repo update # Update CocoaPods repo
```

**Android Build Issues:**
```bash
flutter clean             # Clean build cache
make setup-android        # Reinstall Android tools
```

**Dependencies Issues:**
```bash
make fix-deps             # Fix dependency conflicts
make clean-all            # Deep clean everything
```

### Getting Help

- **GitHub Issues**: Report bugs and request features
- **Flutter Documentation**: https://flutter.dev/docs
- **Living Twin Web Platform**: Connect to same backend APIs
- **Make Commands**: `make help` for all available commands

## 🔗 Related Projects

- **[Living Twin Web Platform](../living_twin_monorepo/)** - Main web application
- **[Living Twin Simulation](../living-twin-simulation/)** - Organizational behavior modeling
- **Living Twin Desktop** - Future desktop applications

---

**Ready to build the future of organizational intelligence on mobile? Let's get started!** 🚀📱