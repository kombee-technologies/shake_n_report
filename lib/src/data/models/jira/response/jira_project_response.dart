class JiraProjectsResponse {
  String? self;
  int? maxResults;
  int? startAt;
  int? total;
  bool? isLast;
  List<ProjectItem>? values;

  JiraProjectsResponse({
    this.self,
    this.maxResults,
    this.startAt,
    this.total,
    this.isLast,
    this.values,
  });

  factory JiraProjectsResponse.fromMap(Map<String, dynamic> json) => JiraProjectsResponse(
        self: json['self'] as String?,
        maxResults: json['maxResults'] as int?,
        startAt: json['startAt'] as int?,
        total: json['total'] as int?,
        isLast: json['isLast'] as bool?,
        values: json['values'] == null
            ? <ProjectItem>[]
            // ignore: always_specify_types
            : List<ProjectItem>.from((json['values'] as List<dynamic>).map((x) => ProjectItem.fromMap(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'self': self,
        'maxResults': maxResults,
        'startAt': startAt,
        'total': total,
        'isLast': isLast,
        'values': values == null ? <dynamic>[] : List<dynamic>.from(values!.map((ProjectItem x) => x.toMap())),
      };
}

class ProjectItem {
  String? expand;
  String? self;
  String? id;
  String? key;
  String? name;
  AvatarUrls? avatarUrls;
  String? projectTypeKey;
  bool? simplified;
  String? style;
  bool? isPrivate;
  String? entityId;
  String? uuid;

  ProjectItem({
    this.expand,
    this.self,
    this.id,
    this.key,
    this.name,
    this.avatarUrls,
    this.projectTypeKey,
    this.simplified,
    this.style,
    this.isPrivate,
    this.entityId,
    this.uuid,
  });

  factory ProjectItem.fromMap(Map<String, dynamic> json) => ProjectItem(
        expand: json['expand'] as String?,
        self: json['self'] as String?,
        id: json['id'] as String?,
        key: json['key'] as String?,
        name: json['name'] as String?,
        avatarUrls: json['avatarUrls'] == null ? null : AvatarUrls.fromMap(json['avatarUrls'] as Map<String, dynamic>),
        projectTypeKey: json['projectTypeKey'] as String?,
        simplified: json['simplified'] as bool?,
        style: json['style'] as String?,
        isPrivate: json['isPrivate'] as bool?,
        entityId: json['entityId'] as String?,
        uuid: json['uuid'] as String?,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'expand': expand,
        'self': self,
        'id': id,
        'key': key,
        'name': name,
        'avatarUrls': avatarUrls?.toMap(),
        'projectTypeKey': projectTypeKey,
        'simplified': simplified,
        'style': style,
        'isPrivate': isPrivate,
        'entityId': entityId,
        'uuid': uuid,
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
