class JiraConfig {
  String? clientId;
  String? clientSecret;
  String? redirectUrl;

  JiraConfig({
    this.clientId,
    this.clientSecret,
    this.redirectUrl,
  });

  // check all values are not null and not empty
  bool isValid() => clientId != null && clientSecret != null && redirectUrl != null &&
      clientId?.isNotEmpty == true && clientSecret?.isNotEmpty == true && redirectUrl?.isNotEmpty == true;
}