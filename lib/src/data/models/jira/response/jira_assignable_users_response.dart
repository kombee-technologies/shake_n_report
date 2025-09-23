import 'dart:convert';

List<JiraAssignableUsersResponse> jiraAssignableUsersResponseFromMap(
        List<dynamic> json) =>
    List<JiraAssignableUsersResponse>.from(
// ignore: always_specify_types
        json.map((x) =>
            JiraAssignableUsersResponse.fromMap(x as Map<String, dynamic>)));

String jiraAssignableUsersResponseToMap(
        List<JiraAssignableUsersResponse> data) =>
    json.encode(List<dynamic>.from(
        data.map((JiraAssignableUsersResponse x) => x.toMap())));

class JiraAssignableUsersResponse {
  String? self;
  String? accountId;
  String? accountType;
  String? emailAddress;
  AvatarUrls? avatarUrls;
  String? displayName;
  bool? active;
  String? timeZone;
  String? locale;

  JiraAssignableUsersResponse({
    this.self,
    this.accountId,
    this.accountType,
    this.emailAddress,
    this.avatarUrls,
    this.displayName,
    this.active,
    this.timeZone,
    this.locale,
  });

  factory JiraAssignableUsersResponse.fromMap(Map<String, dynamic> json) =>
      JiraAssignableUsersResponse(
        self: json['self'] as String?,
        accountId: json['accountId'] as String?,
        accountType: json['accountType'] as String?,
        emailAddress: json['emailAddress'] as String?,
        avatarUrls: json['avatarUrls'] == null
            ? null
            : AvatarUrls.fromMap(json['avatarUrls'] as Map<String, dynamic>),
        displayName: json['displayName'] as String?,
        active: json['active'] as bool?,
        timeZone: json['timeZone'] as String?,
        locale: json['locale'] as String?,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'self': self,
        'accountId': accountId,
        'accountType': accountType,
        'emailAddress': emailAddress,
        'avatarUrls': avatarUrls?.toMap(),
        'displayName': displayName,
        'active': active,
        'timeZone': timeZone,
        'locale': locale,
      };
}

class AvatarUrls {
  String? the48X48;
  String? the24X24;
  String? the16X16;
  String? the32X32;

  AvatarUrls({
    this.the48X48,
    this.the24X24,
    this.the16X16,
    this.the32X32,
  });

  factory AvatarUrls.fromMap(Map<String, dynamic> json) => AvatarUrls(
        the48X48: json['48x48'] as String?,
        the24X24: json['24x24'] as String?,
        the16X16: json['16x16'] as String?,
        the32X32: json['32x32'] as String?,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        '48x48': the48X48,
        '24x24': the24X24,
        '16x16': the16X16,
        '32x32': the32X32,
      };
}
