class CreateJiraIssueResponse {
    String? id;
    String? key;
    String? self;

    CreateJiraIssueResponse({
        this.id,
        this.key,
        this.self,
    });

    factory CreateJiraIssueResponse.fromMap(Map<String, dynamic> json) => CreateJiraIssueResponse(
        id: json['id'] as String?,
        key: json['key'] as String?,
        self: json['self'] as String?,
    );

    Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'key': key,
        'self': self,
    };
}
