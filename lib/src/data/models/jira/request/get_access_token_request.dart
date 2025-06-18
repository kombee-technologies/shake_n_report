class GetAccessTokenRequest {
  /// The grant type for the request. In this case, it is "authorization_code".
  final String? grantType;

  /// The client ID for the application.
  final String? clientId;

  /// The client secret for the application.
  final String? clientSecret;

  /// The authorization code received from the authorization server.
  final String? code;

  /// The redirect URI used in the authorization request.
  final String? redirectUri;

  /// refresh token
  final String? refreshToken;

  /// Constructor for creating a [GetAccessTokenRequest] object.
  GetAccessTokenRequest({
    this.grantType,
    this.clientId,
    this.clientSecret,
    this.code,
    this.redirectUri,
    this.refreshToken,
  });

  /// Converts the [GetAccessTokenRequest] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        if (grantType != null) 'grant_type': grantType,
        if (clientId != null) 'client_id': clientId,
        if (clientSecret != null) 'client_secret': clientSecret,
        if (code != null) 'code': code,
        if (redirectUri != null) 'redirect_uri': redirectUri,
        if (refreshToken != null) 'refresh_token': refreshToken,
      };
}
