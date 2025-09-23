import 'dart:convert';

List<JiraIssueTypeResponse> jiraIssueTypeResponseFromMap(List<dynamic> json) =>
// ignore: always_specify_types
    List<JiraIssueTypeResponse>.from(json
        // ignore: always_specify_types
        .map((x) => JiraIssueTypeResponse.fromMap(x as Map<String, dynamic>)));

String jiraIssueTypeResponseToMap(List<JiraIssueTypeResponse> data) =>
    json.encode(
        List<dynamic>.from(data.map((JiraIssueTypeResponse x) => x.toMap())));

class JiraIssueTypeResponse {
  String? self;
  String? id;
  String? description;
  String? iconUrl;
  String? name;
  String? untranslatedName;
  bool? subtask;
  int? avatarId;
  int? hierarchyLevel;
  Scope? scope;

  JiraIssueTypeResponse({
    this.self,
    this.id,
    this.description,
    this.iconUrl,
    this.name,
    this.untranslatedName,
    this.subtask,
    this.avatarId,
    this.hierarchyLevel,
    this.scope,
  });

  factory JiraIssueTypeResponse.fromMap(Map<String, dynamic> json) =>
      JiraIssueTypeResponse(
        self: json['self'] as String?,
        id: json['id'] as String?,
        description: json['description'] as String?,
        iconUrl: json['iconUrl'] as String?,
        name: json['name'] as String?,
        untranslatedName: json['untranslatedName'] as String?,
        subtask: json['subtask'] as bool?,
        avatarId: json['avatarId'] as int?,
        hierarchyLevel: json['hierarchyLevel'] as int?,
        scope: json['scope'] == null
            ? null
            : Scope.fromMap(json['scope'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'self': self,
        'id': id,
        'description': description,
        'iconUrl': iconUrl,
        'name': name,
        'untranslatedName': untranslatedName,
        'subtask': subtask,
        'avatarId': avatarId,
        'hierarchyLevel': hierarchyLevel,
        'scope': scope?.toMap(),
      };
}

class Scope {
  String? type;
  Project? project;

  Scope({
    this.type,
    this.project,
  });

  factory Scope.fromMap(Map<String, dynamic> json) => Scope(
        type: json['type'] as String?,
        project: json['project'] == null
            ? null
            : Project.fromMap(json['project'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'type': type,
        'project': project?.toMap(),
      };
}

class Project {
  String? id;

  Project({
    this.id,
  });

  factory Project.fromMap(Map<String, dynamic> json) => Project(
        id: json['id'] as String?,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
      };
}
