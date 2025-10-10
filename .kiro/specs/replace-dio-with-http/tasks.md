# Implementation Plan

- [x] 1. Create core HTTP infrastructure classes
  - Create HttpResponse, HttpLogger, HttpErrorHandler, MultipartHelper, and HttpClientWrapper classes with all necessary methods
  - Implement timeout handling using Future.timeout()
  - Implement error mapping logic for all HTTP status codes
  - Implement debug logging with chunked output
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 5.1, 5.2, 5.3, 5.4, 5.5, 8.1, 8.2, 8.3, 8.4, 8.5_

- [x] 2. Update dependency injection configuration
  - Modify di.dart to register HttpClientWrapper as singleton using GetIt
  - Remove DioFactory registration from GetIt
  - Ensure LocalStorage is available for HttpClientWrapper injection
  - _Requirements: 1.6, 1.7, 8.5_

- [x] 3. Migrate JiraDataSource OAuth and authentication methods
  - Update getAccessToken() to use HttpClientWrapper with form-encoded POST request
  - Update getAccessibleResources() to use HttpClientWrapper with Bearer token authentication
  - Update JiraDataSourceImpl constructor to accept HttpClientWrapper instead of DioFactory
  - _Requirements: 4.1, 4.2, 7.5, 7.6_

- [x] 4. Migrate JiraDataSource project and issue type methods
  - Update getJiraProjects() to use HttpClientWrapper GET request with Bearer token
  - Update getJiraIssueTypes() to use HttpClientWrapper GET request with Bearer token
  - Update getJiraAssignableUsers() to use HttpClientWrapper GET request with Bearer token
  - _Requirements: 4.3, 4.4, 4.5, 7.5, 7.6_

- [x] 5. Migrate JiraDataSource ticket creation and assignment methods
  - Update createJiraTicket() to use HttpClientWrapper POST request with JSON payload
  - Update assignTicket() to use HttpClientWrapper PUT request with JSON payload
  - _Requirements: 4.6, 4.7, 7.5, 7.6_

- [x] 6. Migrate JiraDataSource file attachment method
  - Update addAttachmentToTicket() to use HttpClientWrapper multipart POST request
  - Implement proper multipart/form-data encoding with X-Atlassian-Token header
  - _Requirements: 4.8, 5.1, 5.2, 5.3, 5.4, 5.5, 7.5, 7.6_

- [x] 7. Update dependencies and remove Dio files
  - Remove dio dependency from pubspec.yaml
  - Add http package dependency to pubspec.yaml
  - Delete dio_factory.dart file
  - Delete exceptions_interceptor.dart file
  - Delete logger_intercepter.dart file
  - Remove all Dio imports from the codebase
  - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [x] 8. Verify backward compatibility and test integration
  - Run existing tests to ensure all functionality works
  - Verify all public APIs remain unchanged
  - Verify response formats match previous implementation
  - Verify exception types and messages are consistent
  - Test OAuth flow, project fetching, ticket creation, and file upload manually
  - _Requirements: 7.1, 7.2, 7.3, 7.4_
