// To parse this JSON data, do
//
//     final accessibleResourcesResponse = accessibleResourcesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';

List<AccessibleResourcesResponse> accessibleResourcesResponseFromJson(List<dynamic> json) =>
    List<AccessibleResourcesResponse>.from(
        // ignore: always_specify_types
        json.map((x) => AccessibleResourcesResponse.fromJson(x as Map<String, dynamic>)));

String accessibleResourcesResponseToJson(List<AccessibleResourcesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((AccessibleResourcesResponse x) => x.toJson())));

class AccessibleResourcesResponse {
  String? id;
  String? url;
  String? name;
  List<String>? scopes;
  String? avatarUrl;

  List<ProjectItem>? projects;
  String? errorStr;

  AccessibleResourcesResponse({
    this.id,
    this.url,
    this.name,
    this.scopes,
    this.avatarUrl,
    this.projects,
    this.errorStr,
  });

  // copy with 
  AccessibleResourcesResponse copyWith({
    String? id,
    String? url,
    String? name,
    List<String>? scopes,
    String? avatarUrl,
    List<ProjectItem>? projects,
    String? errorStr,
  }) =>
      AccessibleResourcesResponse(
        id: id ?? this.id,
        url: url ?? this.url,
        name: name ?? this.name,
        scopes: scopes ?? this.scopes,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        projects: projects ?? this.projects,
        errorStr: errorStr ?? this.errorStr,
      );


  factory AccessibleResourcesResponse.fromJson(Map<String, dynamic> json) => AccessibleResourcesResponse(
        id: json['id'] as String?,
        url: json['url'] as String?,
        name: json['name'] as String?,
        scopes:
            // ignore: always_specify_types
            json['scopes'] == null ? <String>[] : List<String>.from((json['scopes'] as List<dynamic>).map((x) => x)),
        avatarUrl: json['avatarUrl'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'url': url,
        'name': name,
        'scopes': scopes == null ? <dynamic>[] : List<dynamic>.from(scopes!.map((String x) => x)),
        'avatarUrl': avatarUrl,
      };
}
