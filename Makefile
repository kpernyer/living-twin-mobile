# =========================
# Living Twin Mobile - Flutter/Dart Makefile
# =========================
# 
# Cross-platform mobile app development with Flutter
# Supports iOS, Android, Web, macOS, Windows, Linux
# Hybrid Docker + Native toolchain approach
# =========================

.PHONY: help install setup-ios setup-android dev-ios dev-android dev-web build-ios build-android build-web test lint format clean docker-build docker-run

# Default target
help:
	@echo "📱 Living Twin Mobile - Flutter Commands"
	@echo "========================================"
	@echo ""
	@echo "🚀 Quick Start:"
	@echo "  install                                 Install Flutter and dependencies"
	@echo "  setup                                   Complete environment setup"
	@echo "  dev                                     Start development on current platform"
	@echo ""
	@echo "📱 Development:"
	@echo "  dev-ios                                 Run on iOS simulator"
	@echo "  dev-android                             Run on Android emulator/device"
	@echo "  dev-web                                 Run on web browser"
	@echo "  dev-macos                               Run on macOS (if supported)"
	@echo "  dev-windows                             Run on Windows (if supported)"
	@echo "  dev-linux                               Run on Linux (if supported)"
	@echo ""
	@echo "🏗️  Build & Release:"
	@echo "  build-ios                               Build iOS app bundle"
	@echo "  build-android-apk                       Build Android APK"
	@echo "  build-android-aab                       Build Android App Bundle"
	@echo "  build-web                               Build web application"
	@echo "  build-all                               Build for all platforms"
	@echo ""
	@echo "🐳 Docker Development:"
	@echo "  docker-build                            Build Flutter development container"
	@echo "  docker-dev                              Run development in container"
	@echo "  docker-build-web                        Build web app in container"
	@echo "  docker-test                             Run tests in container"
	@echo ""
	@echo "🔧 Environment Setup:"
	@echo "  setup-flutter                           Install/update Flutter SDK"
	@echo "  setup-ios                               Setup iOS development tools"
	@echo "  setup-android                           Setup Android development tools"
	@echo "  setup-web                               Setup web development tools"
	@echo "  doctor                                  Run Flutter doctor diagnostic"
	@echo ""
	@echo "🧪 Testing & Quality:"
	@echo "  test                                    Run all tests"
	@echo "  test-unit                               Run unit tests only"
	@echo "  test-widget                             Run widget tests only"
	@echo "  test-integration                        Run integration tests"
	@echo "  test-coverage                           Generate test coverage report"
	@echo "  lint                                    Run Dart analyzer"
	@echo "  format                                  Format Dart code"
	@echo ""
	@echo "🏃 API Integration:"
	@echo "  connect-local                           Connect to local Living Twin API (localhost:8000)"
	@echo "  connect-staging                         Connect to staging API"
	@echo "  connect-prod                            Connect to production API"
	@echo ""
	@echo "🧹 Maintenance:"
	@echo "  clean                                   Clean build artifacts"
	@echo "  clean-all                               Deep clean (including Flutter cache)"
	@echo "  update-deps                             Update dependencies"
	@echo "  fix-deps                                Fix dependency conflicts"

# =========================
# Environment Detection
# =========================

OS := $(shell uname)
FLUTTER_CHANNEL := stable

# Detect Flutter installation
FLUTTER_CMD := $(shell command -v flutter 2> /dev/null)
ifndef FLUTTER_CMD
    FLUTTER_CMD := $(HOME)/.flutter/bin/flutter
endif

# =========================
# Quick Start Commands
# =========================

install: setup-flutter setup-deps
	@echo "✅ Installation complete! Run 'make dev' to start development"

setup: setup-flutter setup-deps setup-platform
	@echo "✅ Complete setup finished!"

dev: doctor
	@echo "🚀 Starting development on current platform..."
	$(FLUTTER_CMD) run

# =========================
# Platform-Specific Development
# =========================

dev-ios:
	@echo "📱 Starting iOS development..."
	@if [ "$(OS)" != "Darwin" ]; then \
		echo "❌ iOS development requires macOS"; \
		exit 1; \
	fi
	$(FLUTTER_CMD) run -d ios

dev-android:
	@echo "🤖 Starting Android development..."
	$(FLUTTER_CMD) run -d android

dev-web:
	@echo "🌐 Starting web development..."
	$(FLUTTER_CMD) run -d chrome --web-port=3000

dev-macos:
	@echo "💻 Starting macOS development..."
	@if [ "$(OS)" != "Darwin" ]; then \
		echo "❌ macOS development requires macOS"; \
		exit 1; \
	fi
	$(FLUTTER_CMD) run -d macos

dev-windows:
	@echo "🪟 Starting Windows development..."
	$(FLUTTER_CMD) run -d windows

dev-linux:
	@echo "🐧 Starting Linux development..."
	$(FLUTTER_CMD) run -d linux

# =========================
# Build Commands
# =========================

build-ios:
	@echo "📱 Building iOS app..."
	@if [ "$(OS)" != "Darwin" ]; then \
		echo "❌ iOS builds require macOS and Xcode"; \
		exit 1; \
	fi
	$(FLUTTER_CMD) build ios

build-android-apk:
	@echo "🤖 Building Android APK..."
	$(FLUTTER_CMD) build apk

build-android-aab:
	@echo "🤖 Building Android App Bundle..."
	$(FLUTTER_CMD) build appbundle

build-web:
	@echo "🌐 Building web application..."
	$(FLUTTER_CMD) build web

build-all: build-android-apk build-web
	@echo "🏗️  Building for all available platforms..."
	@if [ "$(OS)" = "Darwin" ]; then \
		$(MAKE) build-ios; \
	fi

# =========================
# Docker Development
# =========================

docker-build:
	@echo "🐳 Building Flutter development container..."
	docker build -f docker/Dockerfile.flutter -t living-twin-mobile:dev .

docker-dev:
	@echo "🐳 Running Flutter development in container..."
	docker run -it --rm \
		-v $(PWD):/app \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=$(DISPLAY) \
		-p 3000:3000 \
		living-twin-mobile:dev \
		flutter run -d web-server --web-port=3000 --web-hostname=0.0.0.0

docker-build-web:
	@echo "🐳 Building web app in container..."
	docker run --rm \
		-v $(PWD):/app \
		-w /app \
		living-twin-mobile:dev \
		flutter build web

docker-test:
	@echo "🐳 Running tests in container..."
	docker run --rm \
		-v $(PWD):/app \
		-w /app \
		living-twin-mobile:dev \
		flutter test

# =========================
# Environment Setup
# =========================

setup-flutter:
	@echo "📱 Setting up Flutter SDK..."
	@if [ ! -d "$(HOME)/.flutter" ] && [ -z "$(FLUTTER_CMD)" ]; then \
		echo "📥 Downloading Flutter SDK..."; \
		git clone https://github.com/flutter/flutter.git -b $(FLUTTER_CHANNEL) $(HOME)/.flutter; \
		echo "🔗 Adding Flutter to PATH..."; \
		echo 'export PATH="$$HOME/.flutter/bin:$$PATH"' >> $(HOME)/.zshrc; \
		echo 'export PATH="$$HOME/.flutter/bin:$$PATH"' >> $(HOME)/.bashrc; \
	fi
	@$(FLUTTER_CMD) --version
	@$(FLUTTER_CMD) config --no-analytics

setup-deps:
	@echo "📦 Installing Flutter dependencies..."
	$(FLUTTER_CMD) pub get
	$(FLUTTER_CMD) pub deps

setup-ios:
	@echo "📱 Setting up iOS development tools..."
	@if [ "$(OS)" != "Darwin" ]; then \
		echo "⚠️  iOS setup only available on macOS"; \
		exit 0; \
	fi
	@echo "🔍 Checking Xcode installation..."
	@if ! command -v xcodebuild &> /dev/null; then \
		echo "❌ Xcode not found. Please install from App Store"; \
		exit 1; \
	fi
	@echo "🔍 Checking CocoaPods..."
	@if ! command -v pod &> /dev/null; then \
		echo "📥 Installing CocoaPods..."; \
		sudo gem install cocoapods; \
	fi
	@echo "🔧 Setting up iOS simulator..."
	$(FLUTTER_CMD) doctor --android-licenses || true
	@echo "✅ iOS setup complete"

setup-android:
	@echo "🤖 Setting up Android development tools..."
	@echo "🔍 Checking Android SDK..."
	@if [ ! -d "$$HOME/Library/Android/sdk" ] && [ ! -d "$$HOME/Android/Sdk" ]; then \
		echo "❌ Android SDK not found. Please install Android Studio"; \
		echo "📖 Visit: https://developer.android.com/studio"; \
		exit 1; \
	fi
	@echo "📄 Accepting Android licenses..."
	$(FLUTTER_CMD) doctor --android-licenses
	@echo "✅ Android setup complete"

setup-web:
	@echo "🌐 Setting up web development..."
	$(FLUTTER_CMD) config --enable-web
	@echo "✅ Web setup complete"

setup-platform:
	@echo "🔧 Setting up platform-specific tools..."
	@if [ "$(OS)" = "Darwin" ]; then \
		$(MAKE) setup-ios; \
	fi
	$(MAKE) setup-android || echo "⚠️  Android setup failed, continuing..."
	$(MAKE) setup-web

doctor:
	@echo "🏥 Running Flutter doctor..."
	$(FLUTTER_CMD) doctor -v

# =========================
# API Connection
# =========================

connect-local:
	@echo "🔗 Configuring for local Living Twin API..."
	@echo "API_BASE_URL=http://localhost:8000" > .env.local
	@echo "GRAPHQL_URL=http://localhost:8000/graphql" >> .env.local
	@echo "✅ Connected to local API (localhost:8000)"

connect-staging:
	@echo "🔗 Configuring for staging API..."
	@echo "API_BASE_URL=https://staging.aprio.one/api" > .env.staging
	@echo "GRAPHQL_URL=https://staging.aprio.one/api/graphql" >> .env.staging
	@echo "✅ Connected to staging API (staging.aprio.one)"

connect-prod:
	@echo "🔗 Configuring for production API..."
	@echo "API_BASE_URL=https://dev.aprio.one/api" > .env.production
	@echo "GRAPHQL_URL=https://dev.aprio.one/api/graphql" >> .env.production
	@echo "✅ Connected to production API (dev.aprio.one)"

# =========================
# Testing & Quality
# =========================

test:
	@echo "🧪 Running all tests..."
	$(FLUTTER_CMD) test

test-unit:
	@echo "🧪 Running unit tests..."
	$(FLUTTER_CMD) test test/unit/

test-widget:
	@echo "🧪 Running widget tests..."
	$(FLUTTER_CMD) test test/widget/

test-integration:
	@echo "🧪 Running integration tests..."
	$(FLUTTER_CMD) test integration_test/

test-coverage:
	@echo "📊 Generating test coverage..."
	$(FLUTTER_CMD) test --coverage
	@if command -v genhtml &> /dev/null; then \
		genhtml coverage/lcov.info -o coverage/html; \
		echo "📋 Coverage report: coverage/html/index.html"; \
	fi

lint:
	@echo "🔍 Running Dart analyzer..."
	$(FLUTTER_CMD) analyze

format:
	@echo "✨ Formatting Dart code..."
	$(FLUTTER_CMD) format lib/ test/

# =========================
# Maintenance
# =========================

clean:
	@echo "🧹 Cleaning build artifacts..."
	$(FLUTTER_CMD) clean

clean-all: clean
	@echo "🧹 Deep cleaning..."
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf .flutter-plugins-dependencies
	$(FLUTTER_CMD) pub cache clean

update-deps:
	@echo "📦 Updating dependencies..."
	$(FLUTTER_CMD) pub upgrade

fix-deps:
	@echo "🔧 Fixing dependency conflicts..."
	$(FLUTTER_CMD) pub deps
	$(FLUTTER_CMD) pub get

# =========================
# Development Shortcuts
# =========================

hot-reload:
	@echo "🔥 Triggering hot reload..."
	@echo "r" > /tmp/flutter_input

hot-restart:
	@echo "🔄 Triggering hot restart..."
	@echo "R" > /tmp/flutter_input