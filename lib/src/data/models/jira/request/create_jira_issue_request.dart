class CreateJiraIssueRequest {
  Fields? fields;

  CreateJiraIssueRequest({
    this.fields,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fields': fields?.toMap(),
      };
}

class Fields {
  Issuetype? project;
  String? summary;
  Description? description;
  Issuetype? issuetype;

  Fields({
    this.project,
    this.summary,
    this.description,
    this.issuetype,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'project': project?.toMap(),
        'summary': summary,
        'description': description?.toMap(),
        'issuetype': issuetype?.toMap(),
      };
}

class Description {
  String? type;
  int? version;
  List<DescriptionContent>? content;

  Description({
    this.type,
    this.version,
    this.content,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'type': type,
        'version': version,
        'content':
            content == null ? <dynamic>[] : List<dynamic>.from(content!.map((DescriptionContent x) => x.toMap())),
      };
}

class DescriptionContent {
  String? type;
  List<ContentContent>? content;

  DescriptionContent({
    this.type,
    this.content,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'type': type,
        'content': content == null ? <dynamic>[] : List<dynamic>.from(content!.map((ContentContent x) => x.toMap())),
      };
}

class ContentContent {
  String? type;
  String? text;

  ContentContent({
    this.type,
    this.text,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'type': type,
        'text': text,
      };
}

class Issuetype {
  String? id;

  Issuetype({
    this.id,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
      };
}
