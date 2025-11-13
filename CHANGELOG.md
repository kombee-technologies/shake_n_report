## 0.0.5-beta.2

* **WASM Compatibility Improvements**: Enhanced WASM compatibility by making all `dart:io` dependencies conditional
  - Made `flutter_secure_storage` usage conditional with stub implementation for web/WASM
  - Made `device_info_plus` usage conditional to prevent `dart:io` import chain
  - Created conditional import structure for `LocalStorage` class
  - Package now fully compatible with WASM runtime analysis
* **Code Quality**: Fixed static analysis issues
  - Fixed angle brackets in documentation comments (replaced `<T>` with descriptive text)
  - All documentation now passes linter checks
  - Improved code documentation clarity

## 0.0.5-beta.1

* **WASM Compatibility**: Fixed WASM compatibility issues by removing `dart:io` from import chain
  - Added conditional imports for platform detection
  - Replaced `Image.file()` with `Image.memory()` for cross-platform image display
  - Created platform helper utilities with stub implementations for web/WASM
* **Platform Restrictions**: Added runtime checks to ensure plugin only works on Android and iOS
  - Added platform validation in plugin initialization
  - Added platform checks in shake detection widget
  - Clear error messages for unsupported platforms
* **Documentation**: Fixed broken screenshot images in README.md
  - Changed GitHub blob URLs to raw URLs for proper image display on pub.dev
  - Fixed class name inconsistency in README examples

## 0.0.4

* Fix the broken links

## 0.0.3

* **Dependency optimization**: Migrated from Dio to standard `http` package, reducing external dependencies
* **Documentation improvements**: 
  - Updated requirements section with accurate Flutter, Dart SDK, iOS, and Android versions
  - Added comprehensive permissions setup guide for Android and iOS
  - Organized screenshots in responsive grid layout
* **Code quality**: Improved network layer with better error handling and logging

## 0.0.2

* Support only for Android and iOS

## 0.0.1

* initial release.
