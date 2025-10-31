import 'package:flutter/cupertino.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_issue_type_response.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';
import 'package:shake_n_report/src/presentation/widgets/cache_network_image_widget.dart';
import 'package:shake_n_report/src/presentation/widgets/custom_autocomplete_widget.dart';

class JiraIssueTypeDropdownWidget extends StatelessWidget {
  const JiraIssueTypeDropdownWidget(
      {required this.jiraManagementState,
      required this.isSubmitting,
      required this.onSelected,
      super.key});

  final JiraManagementState jiraManagementState;

  final void Function(JiraIssueTypeResponse? selection) onSelected;

  final bool isSubmitting;

  @override
  Widget build(BuildContext context) => (jiraManagementState
              .isIssueTypeLoading ??
          false)
      ? const Padding(
          padding: EdgeInsets.all(16.0),
          child: CupertinoActivityIndicator(),
        )
      : CustomAutocompleteField<JiraIssueTypeResponse>(
          labelText: 'Issue Type',
          hintText: 'Type to search issue type',
          isReadOnly: isSubmitting,
          options: jiraManagementState.issueTypes ?? <JiraIssueTypeResponse>[],
          initialValue: jiraManagementState.selectedIssueTypeID,
          displayStringForOption: (JiraIssueTypeResponse option) =>
              option.name ?? '',
          onSelected: (JiraIssueTypeResponse selection) {
            onSelected(selection);
          },
          filterCondition: (JiraIssueTypeResponse option, String query) =>
              option.name?.toLowerCase().contains(query.toLowerCase()) ?? false,
          optionViewBuilder:
              (BuildContext context, JiraIssueTypeResponse issueType) =>
                  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Text(issueType.name ?? ''),
              ],
            ),
          ),
          validator: (String? value) {
            if (jiraManagementState.selectedIssueTypeID == null) {
              return 'Please select an issue type.';
            }
            return null;
          },
          onClear: () {
            onSelected(null);
          },
        );
}
