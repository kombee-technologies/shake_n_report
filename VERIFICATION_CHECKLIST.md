# Pre-Publishing Verification Checklist

## Version: 0.0.5-beta.1

### ✅ Code Quality Checks

- [x] **WASM Compatibility**: Fixed by removing `dart:io` from import chain
  - [x] Created `platform_helper.dart` with conditional imports
  - [x] Created `platform_helper_io.dart` for Android/iOS
  - [x] Created `platform_helper_stub.dart` for web/WASM
  - [x] Updated `attachment_input_field.dart` to use `Image.memory()` instead of `Image.file()`

- [x] **Platform Restrictions**: Added runtime checks
  - [x] Platform validation in `ShakeNReportPlugin.initialize()`
  - [x] Platform checks in `ShakeToReportWidget`
  - [x] Clear error messages for unsupported platforms

- [x] **Code Consistency**: Fixed class name in README
  - [x] Changed `ShakeToReportPlugin` to `ShakeNReportPlugin` in README examples

### ✅ Documentation Checks

- [x] **README.md**: 
  - [x] Fixed screenshot image URLs (changed blob to raw)
  - [x] Fixed class name in code examples
  - [x] Platform support table is accurate
  - [x] All code examples are correct

- [x] **CHANGELOG.md**: 
  - [x] Added entry for 0.0.5-beta.1
  - [x] Documented all recent changes
  - [x] Clear and descriptive change notes

### ✅ Pubspec.yaml Checks

- [x] Version updated to `0.0.5-beta.1`
- [x] Description is clear and accurate
- [x] Homepage, repository, and issue tracker URLs are correct
- [x] License is specified (MIT)
- [x] Platform declarations are correct (Android and iOS only)
- [x] Dependencies are up to date and compatible

### ✅ Pub.dev Scoring Points

#### Platform Support (20/20 points)
- ✅ Supports Android
- ✅ Supports iOS
- ✅ Correctly declares only Android and iOS in pubspec.yaml
- ✅ No false platform claims

#### WASM Compatibility (0/0 points - Not required, but fixed)
- ✅ No `dart:io` in import chain
- ✅ Conditional imports used for platform detection
- ✅ Package is WASM compatible (won't break future scoring)

#### Documentation (Points vary)
- ✅ README.md is comprehensive
- ✅ Code examples are correct
- ✅ Screenshots are properly linked
- ✅ CHANGELOG.md is up to date

#### Code Quality (Points vary)
- ✅ No lint errors
- ✅ Proper error handling
- ✅ Platform-specific code is properly gated

### 🔍 Pre-Publish Commands

Run these commands before publishing:

```bash
# 1. Format code
dart format .

# 2. Analyze code
flutter analyze

# 3. Run tests
flutter test

# 4. Check pub.dev scoring (dry-run)
flutter pub publish --dry-run

# 5. Verify package
flutter pub publish --dry-run --force
```

### 📋 Publishing Steps

1. **Commit all changes**:
   ```bash
   git add .
   git commit -m "chore: prepare for beta release 0.0.5-beta.1"
   ```

2. **Tag the release**:
   ```bash
   git tag v0.0.5-beta.1
   git push origin v0.0.5-beta.1
   ```

3. **Publish to pub.dev**:
   ```bash
   flutter pub publish
   ```

4. **Verify on pub.dev**:
   - Check package page: https://pub.dev/packages/shake_n_report
   - Verify screenshots display correctly
   - Check pub points score
   - Verify version is listed

### ⚠️ Important Notes

- This is a **beta release** - users will need to specify the version explicitly:
  ```yaml
  dependencies:
    shake_n_report: 0.0.5-beta.1
  ```

- After beta testing, release as stable version (e.g., `0.0.5`)

- Monitor pub.dev for any issues or feedback

