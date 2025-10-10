# Requirements Document

## Introduction

This feature involves replacing the Dio HTTP client library with Flutter's default `http` package throughout the shake_n_report plugin. The goal is to reduce external dependencies, simplify the networking layer, and maintain all existing functionality including request/response handling, error management, logging, and multipart file uploads for Jira API integration.

## Requirements

### Requirement 1: HTTP Client Migration

**User Story:** As a developer maintaining the shake_n_report plugin, I want to replace Dio with the standard HTTP package, so that the plugin has fewer external dependencies and uses Flutter's built-in networking capabilities.

#### Acceptance Criteria

1. WHEN the plugin is initialized THEN it SHALL use the `http` package instead of Dio for all network requests
2. WHEN making HTTP requests THEN the system SHALL support GET, POST, and PUT methods
3. WHEN configuring the HTTP client THEN the system SHALL maintain timeout settings (connection: 60s, send: 60s, receive: 60s)
4. WHEN making requests THEN the system SHALL set appropriate default headers including Content-Type: application/json
5. IF a request requires custom headers THEN the system SHALL allow header overrides per request
6. WHEN creating the HTTP client THEN it SHALL be registered as a singleton in GetIt dependency injection container
7. WHEN accessing the HTTP client THEN it SHALL be retrieved from GetIt to ensure single instance usage

### Requirement 2: Error Handling and Exception Management

**User Story:** As a developer, I want comprehensive error handling that matches the current Dio implementation, so that the application can gracefully handle network failures and provide meaningful error messages to users.

#### Acceptance Criteria

1. WHEN a connection timeout occurs THEN the system SHALL throw a TimeoutException with appropriate message
2. WHEN a 401 or 403 status code is received THEN the system SHALL clear local storage AND throw an UnauthorizedException
3. WHEN a 404 status code is received THEN the system SHALL throw a RouteNotFoundException
4. WHEN a 5xx server error occurs THEN the system SHALL throw a ServerException
5. WHEN a connection error occurs THEN the system SHALL throw a ConnectionErrorException
6. WHEN an SSL/TLS certificate error occurs THEN the system SHALL throw a BadCertificateException
7. WHEN an unknown error occurs THEN the system SHALL throw a GeneralException with a default error message
8. WHEN any exception is thrown THEN it SHALL include the original request context for debugging

### Requirement 3: Request and Response Logging

**User Story:** As a developer debugging API issues, I want detailed logging of all HTTP requests and responses in debug mode, so that I can troubleshoot integration problems efficiently.

#### Acceptance Criteria

1. WHEN running in debug mode THEN the system SHALL log all outgoing requests with URI, method, headers, and body
2. WHEN running in debug mode THEN the system SHALL log all incoming responses with status code, headers, and body
3. WHEN running in debug mode THEN the system SHALL log all errors with request details and error information
4. WHEN running in production mode THEN the system SHALL NOT log any request/response details
5. WHEN logging large response bodies THEN the system SHALL chunk output to avoid truncation (800 character chunks)
6. WHEN logging THEN the system SHALL format output with clear delimiters for readability

### Requirement 4: Jira API Integration Compatibility

**User Story:** As a user of the shake_n_report plugin, I want all Jira API integrations to continue working seamlessly after the HTTP client migration, so that I can report bugs without any disruption.

#### Acceptance Criteria

1. WHEN requesting OAuth access tokens THEN the system SHALL successfully POST to the token endpoint with form-encoded data
2. WHEN fetching accessible resources THEN the system SHALL successfully GET with Bearer token authentication
3. WHEN retrieving Jira projects THEN the system SHALL successfully GET and parse project list responses
4. WHEN fetching issue types THEN the system SHALL successfully GET and parse issue type responses
5. WHEN fetching assignable users THEN the system SHALL successfully GET and parse user list responses
6. WHEN creating a Jira ticket THEN the system SHALL successfully POST with JSON payload and return ticket details
7. WHEN assigning a ticket THEN the system SHALL successfully PUT with JSON payload
8. WHEN uploading attachments THEN the system SHALL successfully POST multipart/form-data with file content

### Requirement 5: Multipart File Upload Support

**User Story:** As a user reporting bugs with screenshots, I want to attach images to Jira tickets, so that I can provide visual context for the issues I'm reporting.

#### Acceptance Criteria

1. WHEN uploading file attachments THEN the system SHALL support multipart/form-data encoding
2. WHEN uploading files THEN the system SHALL include proper Content-Type headers for multipart requests
3. WHEN uploading files THEN the system SHALL include the X-Atlassian-Token: no-check header
4. WHEN uploading files THEN the system SHALL properly encode file data and metadata
5. WHEN uploading multiple files THEN the system SHALL support multiple file parts in a single request

### Requirement 6: Dependency Management

**User Story:** As a developer managing the plugin's dependencies, I want to remove Dio from pubspec.yaml and add the HTTP package, so that the dependency tree is updated correctly.

#### Acceptance Criteria

1. WHEN updating dependencies THEN the system SHALL remove `dio: ^5.8.0` from pubspec.yaml
2. WHEN updating dependencies THEN the system SHALL add `http: ^1.2.0` (or latest stable version) to pubspec.yaml
3. WHEN building the project THEN the system SHALL successfully resolve all dependencies without conflicts
4. WHEN running the plugin THEN it SHALL NOT reference any Dio classes or imports

### Requirement 7: Backward Compatibility and Minimal Code Changes

**User Story:** As a user of the shake_n_report plugin, I want the migration to be transparent, so that my existing integration continues to work without any code changes on my end.

#### Acceptance Criteria

1. WHEN the plugin is updated THEN all public APIs SHALL remain unchanged
2. WHEN making API calls THEN the response formats SHALL remain identical to previous versions
3. WHEN errors occur THEN the exception types and messages SHALL remain consistent with previous behavior
4. WHEN the plugin is initialized THEN the configuration interface SHALL remain unchanged
5. WHEN migrating to HTTP package THEN changes SHALL be limited to the network layer (dio_factory.dart, interceptors) and data source implementations only
6. WHEN migrating to HTTP package THEN repository, use case, presentation, and domain layers SHALL remain completely unchanged
7. WHEN organizing network code THEN all HTTP client logic, error handling, and logging SHALL be centralized in the core/networks directory

### Requirement 8: Centralized Network Layer Architecture

**User Story:** As a developer maintaining the codebase, I want all network-related functionality in one centralized location, so that the code is easier to maintain and test.

#### Acceptance Criteria

1. WHEN implementing the HTTP client THEN all network logic SHALL be placed in lib/src/core/networks directory
2. WHEN handling errors THEN error interception logic SHALL be centralized and reusable across all data sources
3. WHEN logging requests THEN logging logic SHALL be centralized and conditionally applied based on debug mode
4. WHEN data sources make API calls THEN they SHALL only interact with the centralized HTTP client wrapper
5. WHEN the HTTP client is needed THEN it SHALL be accessed via GetIt singleton pattern for consistent instance management
