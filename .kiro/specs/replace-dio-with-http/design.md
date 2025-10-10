# Design Document

## Overview

This design outlines the migration from Dio HTTP client to Flutter's native `http` package for the shake_n_report plugin. The migration will maintain all existing functionality while reducing external dependencies. The design focuses on creating a centralized HTTP client wrapper that provides error handling, logging, and request/response management capabilities similar to Dio's interceptor pattern.

The key principle is to minimize code changes by isolating modifications to the network layer (`lib/src/core/networks/`) and data source implementations (`lib/src/data/data_source/remote_data_source/`), leaving all other layers (domain, repository, presentation) completely untouched.

## Architecture

### Current Architecture (Dio-based)
```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│                  (Cubits, Widgets, Pages)                    │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                      Domain Layer                            │
│              (Use Cases, Repository Interfaces)              │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                       Data Layer                             │
│         ┌────────────────────────────────────┐              │
│         │   JiraDataSourceImpl               │              │
│         │   - Uses DioFactory.shared         │              │
│         │   - Makes API calls with Dio       │              │
│         └────────────┬───────────────────────┘              │
│                      │                                       │
│         ┌────────────▼───────────────────────┐              │
│         │   DioFactory (Singleton)           │              │
│         │   - Dio instance with interceptors │              │
│         │   - ExceptionsInterceptor          │              │
│         │   - LoggingInterceptor             │              │
│         └────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────┘
```

### New Architecture (HTTP-based)
```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│                  (Cubits, Widgets, Pages)                    │
│                      [NO CHANGES]                            │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                      Domain Layer                            │
│              (Use Cases, Repository Interfaces)              │
│                      [NO CHANGES]                            │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                       Data Layer                             │
│         ┌────────────────────────────────────┐              │
│         │   JiraDataSourceImpl               │              │
│         │   - Uses HttpClientWrapper         │              │
│         │   - Makes API calls with wrapper   │              │
│         └────────────┬───────────────────────┘              │
│                      │                                       │
│         ┌────────────▼───────────────────────┐              │
│         │   HttpClientWrapper (Singleton)    │              │
│         │   - http.Client instance           │              │
│         │   - Integrated error handling      │              │
│         │   - Integrated logging             │              │
│         │   - Request/Response processing    │              │
│         └────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. HttpClientWrapper

A centralized wrapper class that encapsulates the `http` package client and provides Dio-like functionality.

**Location:** `lib/src/core/networks/http_client_wrapper.dart`

**Responsibilities:**
- Manage a single `http.Client` instance
- Provide methods for GET, POST, PUT requests
- Handle request timeouts
- Apply default and custom headers
- Process responses and handle errors
- Integrate logging in debug mode
- Support multipart file uploads

**Public Interface:**
```dart
class HttpClientWrapper {
  final http.Client _client;
  final LocalStorage _localStorage;
  final Duration connectionTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  
  HttpClientWrapper({
    required LocalStorage localStorage,
    Duration? connectionTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  });

  // GET request
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  // POST request
  Future<HttpResponse<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  });

  // PUT request
  Future<HttpResponse<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  });

  // Multipart POST request
  Future<HttpResponse<T>> postMultipart<T>(
    String url, {
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
  });

  void dispose();
}
```

### 2. HttpResponse

A generic response wrapper that provides type-safe access to response data.

**Location:** `lib/src/core/networks/http_response.dart`

**Structure:**
```dart
class HttpResponse<T> {
  final T? data;
  final int statusCode;
  final Map<String, String> headers;
  final String? statusMessage;

  HttpResponse({
    this.data,
    required this.statusCode,
    required this.headers,
    this.statusMessage,
  });
}
```

### 3. HttpErrorHandler

A utility class that processes HTTP errors and converts them to appropriate exceptions.

**Location:** `lib/src/core/networks/http_error_handler.dart`

**Responsibilities:**
- Analyze HTTP status codes
- Map status codes to custom exceptions
- Handle timeout errors
- Handle connection errors
- Clear local storage on authentication failures

**Public Interface:**
```dart
class HttpErrorHandler {
  final LocalStorage localStorage;

  HttpErrorHandler(this.localStorage);

  Future<void> handleError(
    http.Response? response,
    dynamic error,
    StackTrace stackTrace,
  );
}
```

### 4. HttpLogger

A utility class that logs HTTP requests and responses in debug mode.

**Location:** `lib/src/core/networks/http_logger.dart`

**Responsibilities:**
- Log request details (URL, method, headers, body)
- Log response details (status, headers, body)
- Log errors with context
- Format output for readability
- Chunk large outputs to avoid truncation

**Public Interface:**
```dart
class HttpLogger {
  static void logRequest(
    String method,
    String url,
    Map<String, String>? headers,
    dynamic body,
  );

  static void logResponse(
    String url,
    int statusCode,
    Map<String, String> headers,
    dynamic body,
  );

  static void logError(
    String url,
    dynamic error,
    StackTrace stackTrace,
  );
}
```

### 5. MultipartHelper

A utility class for creating multipart requests.

**Location:** `lib/src/core/networks/multipart_helper.dart`

**Responsibilities:**
- Convert file paths to MultipartFile objects
- Build multipart requests with files and fields
- Handle file encoding and metadata

**Public Interface:**
```dart
class MultipartHelper {
  static Future<http.MultipartFile> fileFromPath(
    String field,
    String filePath,
  );

  static http.MultipartRequest createRequest(
    String method,
    String url,
    List<http.MultipartFile> files,
    Map<String, String>? fields,
  );
}
```

## Data Models

### Request/Response Handling

The existing request and response models in `lib/src/data/models/jira/` will remain unchanged. The HttpClientWrapper will handle serialization/deserialization:

**JSON Requests:**
- Convert Dart objects to JSON using existing `toJson()` or `toMap()` methods
- Set Content-Type: application/json header
- Encode body using `jsonEncode()`

**Form-Encoded Requests:**
- Convert Dart objects to URL-encoded strings
- Set Content-Type: application/x-www-form-urlencoded header
- Use existing `toJson()` methods and encode as form data

**JSON Responses:**
- Parse response body using `jsonDecode()`
- Pass parsed data to existing `fromJson()` or `fromMap()` factory constructors
- Return typed HttpResponse objects

**Multipart Requests:**
- Use `http.MultipartRequest` for file uploads
- Add files as `MultipartFile` objects
- Add fields as string key-value pairs

## Error Handling

### Error Flow

```
HTTP Request → Error Occurs
       ↓
HttpClientWrapper catches exception
       ↓
HttpErrorHandler.handleError()
       ↓
Analyze error type and status code
       ↓
Map to appropriate custom exception
       ↓
Throw custom exception (TimeoutException, UnauthorizedException, etc.)
       ↓
Caught by repository layer (existing error handling)
       ↓
Converted to Either<Failure, Success> (existing pattern)
```

### Error Mapping

| Condition | Exception Type | Action |
|-----------|---------------|--------|
| Connection timeout | TimeoutException | Throw with timeout message |
| Socket exception | ConnectionErrorException | Throw with connection error message |
| TLS/SSL error | BadCertificateException | Throw with certificate error message |
| Status 401/403 | UnauthorizedException | Clear local storage, throw exception |
| Status 404 | RouteNotFoundException | Throw with not found message |
| Status 5xx | ServerException | Throw with server error message |
| Other errors | GeneralException | Throw with generic error message |

### Timeout Implementation

Since the `http` package doesn't have built-in timeout support, we'll use `Future.timeout()`:

```dart
final response = await _client
    .get(uri, headers: headers)
    .timeout(connectionTimeout);
```

## Testing Strategy

### Unit Tests

**HttpClientWrapper Tests:**
- Test GET, POST, PUT methods with various data types
- Test timeout handling
- Test header merging (default + custom)
- Test query parameter encoding
- Test multipart request creation
- Mock http.Client using mockito

**HttpErrorHandler Tests:**
- Test each status code mapping
- Test timeout error handling
- Test connection error handling
- Test local storage clearing on 401/403
- Mock LocalStorage using mockito

**HttpLogger Tests:**
- Test request logging format
- Test response logging format
- Test error logging format
- Test chunking of large outputs
- Verify no logging in production mode

**MultipartHelper Tests:**
- Test file to MultipartFile conversion
- Test multipart request creation with files and fields
- Test file encoding

### Integration Tests

**JiraDataSource Tests:**
- Test each API endpoint with HttpClientWrapper
- Test successful responses
- Test error responses
- Test authentication flow
- Test file upload flow
- Use mock HTTP server (e.g., mockito or http_mock_adapter)

### Migration Validation

**Comparison Tests:**
- Run existing integration tests with Dio
- Run same tests with HTTP wrapper
- Compare response data structures
- Compare error handling behavior
- Ensure identical outcomes

## Implementation Plan

### Phase 1: Core HTTP Infrastructure
1. Create HttpResponse class
2. Create HttpLogger utility
3. Create HttpErrorHandler utility
4. Create MultipartHelper utility
5. Create HttpClientWrapper with basic GET/POST/PUT methods

### Phase 2: Dependency Injection
1. Update di.dart to register HttpClientWrapper as singleton
2. Remove DioFactory registration
3. Update JiraDataSourceImpl constructor to accept HttpClientWrapper

### Phase 3: Data Source Migration
1. Update JiraDataSourceImpl.getAccessToken()
2. Update JiraDataSourceImpl.getAccessibleResources()
3. Update JiraDataSourceImpl.getJiraProjects()
4. Update JiraDataSourceImpl.getJiraIssueTypes()
5. Update JiraDataSourceImpl.getJiraAssignableUsers()
6. Update JiraDataSourceImpl.createJiraTicket()
7. Update JiraDataSourceImpl.assignTicket()
8. Update JiraDataSourceImpl.addAttachmentToTicket()

### Phase 4: Cleanup
1. Remove dio_factory.dart
2. Remove exceptions_interceptor.dart
3. Remove logger_intercepter.dart
4. Update pubspec.yaml (remove dio, add http)
5. Remove all Dio imports from codebase

### Phase 5: Testing & Validation
1. Run all existing tests
2. Test each Jira API endpoint manually
3. Test error scenarios
4. Test file upload functionality
5. Verify logging in debug mode

## File Changes Summary

### Files to Create:
- `lib/src/core/networks/http_client_wrapper.dart`
- `lib/src/core/networks/http_response.dart`
- `lib/src/core/networks/http_error_handler.dart`
- `lib/src/core/networks/http_logger.dart`
- `lib/src/core/networks/multipart_helper.dart`

### Files to Modify:
- `lib/src/core/di.dart` - Update DI registration
- `lib/src/data/data_source/remote_data_source/jira_data_source/jira_data_source.dart` - Update all methods
- `pubspec.yaml` - Update dependencies

### Files to Delete:
- `lib/src/core/networks/dio_factory.dart`
- `lib/src/core/networks/interceptors/exceptions_interceptor.dart`
- `lib/src/core/networks/interceptors/logger_intercepter.dart`

### Files Unchanged:
- All domain layer files (repositories, use cases)
- All presentation layer files (cubits, widgets, pages)
- All data models (request/response classes)
- All repository implementations
- Exception classes
- API endpoint definitions
- API key constants

## Design Decisions & Rationale

### 1. Wrapper Pattern
**Decision:** Create HttpClientWrapper instead of using http.Client directly in data sources.

**Rationale:**
- Centralizes all HTTP logic in one place
- Makes testing easier with a single mock point
- Provides consistent error handling across all requests
- Simplifies future modifications to HTTP behavior
- Maintains similar API to Dio for easier migration

### 2. Integrated Error Handling
**Decision:** Handle errors within HttpClientWrapper instead of using separate interceptors.

**Rationale:**
- The http package doesn't support interceptors
- Integrated approach is simpler and more maintainable
- Reduces number of classes and complexity
- Still provides same error handling capabilities
- Easier to debug with linear error flow

### 3. Timeout with Future.timeout()
**Decision:** Use Future.timeout() for request timeouts instead of http.Client timeout.

**Rationale:**
- http.Client doesn't have built-in timeout configuration
- Future.timeout() provides equivalent functionality
- Allows separate timeouts for connection, send, and receive
- Throws TimeoutException which we can catch and handle

### 4. Singleton via GetIt
**Decision:** Register HttpClientWrapper as singleton in GetIt.

**Rationale:**
- Maintains consistency with existing DI pattern
- Ensures single http.Client instance (connection pooling)
- Easy to access throughout the application
- Simplifies testing with dependency injection
- Matches current DioFactory pattern

### 5. Minimal API Surface
**Decision:** Only implement GET, POST, PUT, and multipart POST methods.

**Rationale:**
- These are the only HTTP methods currently used in the codebase
- Keeps implementation focused and simple
- Easy to add more methods later if needed
- Reduces initial migration complexity

### 6. Type-Safe Responses
**Decision:** Use generic HttpResponse<T> class.

**Rationale:**
- Provides type safety for response data
- Matches Dio's Response<T> pattern
- Makes migration easier for data sources
- Allows compile-time type checking
- Includes status code and headers for debugging
