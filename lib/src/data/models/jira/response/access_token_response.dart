class AccessTokenResponse {
  String? accessToken;
  String? refreshToken;
  int? expiresIn;
  String? tokenType;
  String? scope;

  String? error;
  String? errorDescription;

  AccessTokenResponse(
      {this.accessToken, this.refreshToken, this.expiresIn, this.tokenType, this.scope, this.error, this.errorDescription});

  AccessTokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] as String?;
    refreshToken = json['refresh_token'] as String?;
    expiresIn = json['expires_in'] as int?;
    tokenType = json['token_type'] as String?;
    scope = json['scope'] as String?;
    error = json['error'] as String?;
    errorDescription = json['error_description'] as String?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': expiresIn,
        'token_type': tokenType,
        'scope': scope,
        'error': error,
        'error_description': errorDescription,
      };
}
