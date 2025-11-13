## 0.0.5

* **Complete WASM Compatibility**: Full WASM compatibility achieved through conditional imports
  - Made all `dart:io` dependencies conditional with stub implementations for web/WASM
  - `HttpClientWrapper`, `HttpErrorHandler`, `MultipartHelper`, `LocalStorage`, and `DeviceInfoHelper` now use conditional imports
  - Removed all direct `dart:io` imports from main code paths
  - Package now fully compatible with WASM runtime analysis
* **Code Quality**: Fixed all static analysis issues
  - Fixed angle brackets in documentation comments (replaced `<T>` with descriptive text)
  - All documentation now passes linter checks
  - Improved code documentation clarity
* **Platform Support**: Android and iOS only
  - Clear error messages for unsupported platforms
  - Platform validation in plugin initialization
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
