import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake_n_report/shake_n_report.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_assignable_users_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_issue_type_response.dart';
import 'package:shake_n_report/src/presentation/pages/report_submission/widgets/attachment_input_field.dart';
import 'package:shake_n_report/src/presentation/pages/report_submission/widgets/jira_assignable_user_dropdown_widget.dart';
import 'package:shake_n_report/src/presentation/pages/report_submission/widgets/jira_issue_type_dropdown_widget.dart';
import 'package:shake_n_report/src/presentation/pages/success_page/success_page.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_cubit.dart';

class CreateIssueScreen extends StatefulWidget {
  const CreateIssueScreen({super.key});

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  JiraManagementCubit? _jiraManagementCubit;

  @override
  void initState() {
    _jiraManagementCubit = context.read<JiraManagementCubit>();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jiraManagementCubit?.getAssignableUsers();
      _jiraManagementCubit?.getProjectIssueTypes();
    });
  }

  Future<void> _pickAttachmentsFromDevice() async {
    if ((_jiraManagementCubit?.state.attachments.length ?? 0) >=
        MyConstants.maxAttachments) {
      if (mounted) {
        Utility.showSnackbar(
            msg:
                'You can only attach up to ${MyConstants.maxAttachments} files.',
            bannerStyle: BannerStyle.info);
      }
      return;
    }

    // Using pickMultipleMedia to allow both images and videos.
    // You can also use pickImage or pickVideo separately if needed.
    final List<XFile> pickedXFiles = await _picker.pickMultipleMedia(
      imageQuality: 80, // Optional: for images
      // maxDuration: const Duration(seconds: 60), // Optional: for videos
    );

    if (pickedXFiles.isNotEmpty) {
      _jiraManagementCubit?.onAddAttachments(pickedXFiles);
    }
  }

  void _removeAttachmentFromList(int index) {
    _jiraManagementCubit?.onRemoveAttachment(index);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Create Issue'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
              ),
              onPressed: () {
                context.read<ShakeDetectionCubit>().resetState();
                context.read<JiraManagementCubit>().resetState();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: BlocConsumer<JiraManagementCubit, JiraManagementState>(
                listener: (BuildContext context, JiraManagementState state) {
                  if (!state.isSubmitting &&
                      state.createJiraIssueResponse != null &&
                      state.errorMessage == null) {
                    context.read<ShakeDetectionCubit>().resetState();
                    _jiraManagementCubit?.resetState();
                    // Submission successful
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => SuccessPage(
                          issueId: state.createJiraIssueResponse?.key ?? '',
                        ),
                      ),
                    );
                  } else if (!state.isSubmitting &&
                      state.errorMessage != null) {
                    // Submission failed at some point
                    // Snackbar for specific errors already shown by Cubit.
                    Utility.showSnackbar(
                        msg: 'Submission failed: ${state.errorMessage}',
                        bannerStyle: BannerStyle.error);
                  }
                },
                builder: (BuildContext context, JiraManagementState state) =>
                    Form(
                  //NOSONAR
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(4),
                    children: <Widget>[
                      // Issue Type Autocomplete
                      JiraIssueTypeDropdownWidget(
                        jiraManagementState: state,
                        onSelected: (JiraIssueTypeResponse? item) =>
                            _jiraManagementCubit?.setSelectedIssueType(item),
                        isSubmitting: state.isSubmitting,
                      ),
                      const SizedBox(height: 16),
                      // Title field
                      TextFormField(
                        controller: _titleController,
                        // maxLines: 1,
                        maxLength: 100,
                        readOnly: state.isSubmitting,
                        decoration: InputDecoration(
                          hintText: 'Enter issue title',
                          labelText: 'Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  MyConstants.borderRadius)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          if (value.length < 5) {
                            return 'Title must be at least 5 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Enter issue description',
                          labelText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  MyConstants.borderRadius)),
                          alignLabelWithHint: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        maxLength: 600,
                        readOnly: state.isSubmitting,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          } else if (value.length < 10) {
                            return 'Description must be at least 10 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Assignee Autocomplete
                      JiraAssignableUserDropdownWidget(
                        jiraManagementState: state,
                        onSelected: (JiraAssignableUsersResponse? item) =>
                            _jiraManagementCubit?.setSelectedAssigner(item),
                        isSubmitting: state.isSubmitting,
                      ),

                      const SizedBox(height: 16),
                      // Attachments section
                      AttachmentInputField(
                        attachments: state.attachments,
                        maxAttachments: MyConstants.maxAttachments,
                        onAddAttachment: _pickAttachmentsFromDevice,
                        onRemoveAttachment: _removeAttachmentFromList,
                        isSubmitting: state.isSubmitting,
                      ),

                      const SizedBox(height: 30),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: FilledButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    submitData();
                                  }
                                },
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CupertinoActivityIndicator(),
                                )
                              : const Text('Submit'),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void submitData() {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    _jiraManagementCubit?.submitReport(title: title, description: description);
  }
}
