class AssignIssueRequest {
    String? accountId;

    AssignIssueRequest({
        this.accountId,
    });

    Map<String, dynamic> toMap() => <String, dynamic>{
        'accountId': accountId,
    };
}
