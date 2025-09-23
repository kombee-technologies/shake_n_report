import 'package:flutter/cupertino.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_assignable_users_response.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';
import 'package:shake_n_report/src/presentation/widgets/cache_network_image_widget.dart';
import 'package:shake_n_report/src/presentation/widgets/custom_autocomplete_widget.dart';

class JiraAssignableUserDropdownWidget extends StatelessWidget {
  const JiraAssignableUserDropdownWidget(
      {required this.jiraManagementState,
      required this.onSelected,
      required this.isSubmitting,
      super.key});

  final JiraManagementState jiraManagementState;

  final void Function(JiraAssignableUsersResponse? selection) onSelected;

  final bool isSubmitting;

  @override
  Widget build(BuildContext context) =>
      (jiraManagementState.isAssignableUsersLoading ?? false)
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: CupertinoActivityIndicator(),
            )
          : CustomAutocompleteField<JiraAssignableUsersResponse>(
              labelText: 'Assignee',
              hintText: 'Type to search assignee',
              isReadOnly: isSubmitting,
              options: jiraManagementState.assignableUsers ??
                  <JiraAssignableUsersResponse>[],
              initialValue: jiraManagementState.selectedAssignerAccID,
              displayStringForOption: (JiraAssignableUsersResponse option) =>
                  option.displayName ?? '',
              onSelected: (JiraAssignableUsersResponse selection) {
                onSelected(selection);
              },
              filterCondition:
                  (JiraAssignableUsersResponse option, String query) =>
                      option.displayName
                          ?.toLowerCase()
                          .contains(query.toLowerCase()) ??
                      false,
              optionViewBuilder:
                  (BuildContext context, JiraAssignableUsersResponse user) =>
                      Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    CacheNetworkImageWidget(
                      imageUrl: user.avatarUrls?.the48X48 ?? '',
                      height: 48,
                      width: 48,
                    ),
                    const SizedBox(width: 10),
                    Text(user.displayName ?? ''),
                  ],
                ),
              ),
              validator: (String? value) {
                // The 'value' here is the text in the field.
                // We need to validate based on whether a user object is selected.
                if (jiraManagementState.selectedAssignerAccID == null &&
                    (value != null && value.isNotEmpty)) {
                  return 'Please select a valid user from the list.';
                }
                if (jiraManagementState.selectedAssignerAccID == null) {
                  // If assignee is mandatory
                  return 'Please select an assignee.';
                }
                return null;
              },
              onClear: () {
                onSelected(null);
              },
            );
}
