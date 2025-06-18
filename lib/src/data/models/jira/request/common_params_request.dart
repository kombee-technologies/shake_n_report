class CommonParamsRequest {
  final String? cloudId;
  final String? projectKey;
  final String? projectId;
  final String? issueKey;

  CommonParamsRequest({
    this.cloudId,
    this.projectKey,
    this.projectId,
    this.issueKey,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cloudId != null) {
      data['cloud_id'] = cloudId;
    }
    if (projectKey != null) {
      data['project_key'] = projectKey;
    }
    if (projectId != null) {
      data['project_id'] = projectId;
    }
    if (issueKey != null) {
      data['issue_key'] = issueKey;
    }
    return data;
  }
}
