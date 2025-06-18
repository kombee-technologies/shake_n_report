import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_n_report/src/core/constants/enums.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';
import 'package:shake_n_report/src/presentation/pages/jira_project_selection/widgets/project_card_widget.dart';
import 'package:shake_n_report/src/presentation/pages/report_submission/create_issue_screen.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';
import 'package:shake_n_report/src/presentation/state_management/shake_detection_bloc/shake_detection_cubit.dart';

class ProjectSelectionScreen extends StatefulWidget {
  const ProjectSelectionScreen({super.key});

  @override
  State<ProjectSelectionScreen> createState() => _ProjectSelectionScreenState();
}

class _ProjectSelectionScreenState extends State<ProjectSelectionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final JiraManagementCubit jiraManagementCubit = context.read<JiraManagementCubit>();
      if (jiraManagementCubit.state.projects?.isEmpty ?? false) {
        jiraManagementCubit.getAccessibleResources();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Select Project'),
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
          child: _buildProjectList(),
        ),
      );

  Widget _buildProjectList() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select a project to report an issue:',
            ),
            const SizedBox(height: 16),
            BlocConsumer<JiraManagementCubit, JiraManagementState>(
              listener: (BuildContext context, JiraManagementState state) {
                if (!state.isProjectLoading && state.errorMessage != null) {
                  Utility.showSnackbar(msg: state.errorMessage ?? 'Error occurred', bannerStyle: BannerStyle.error);
                  context.read<JiraManagementCubit>().resetState();
                  context.read<ShakeDetectionCubit>().resetState();
                  Navigator.of(context).pop();
                }
              },
              buildWhen: (JiraManagementState previous, JiraManagementState current) =>
                  (current.errorMessage == null) && !current.isProjectLoading ||
                  (current.projects == previous.projects),
              builder: (BuildContext context, JiraManagementState state) {
                if (state.isProjectLoading) {
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CupertinoActivityIndicator(),
                        SizedBox(height: 8),
                        Text(
                          'Loading projects...',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: state.projects?.length,
                    itemBuilder: (BuildContext context, int index) => ProjectCardWidget(
                      project: state.projects?[index],
                      onTap: (ProjectItem? project) {
                        context.read<JiraManagementCubit>().selectProject(state.projects?[index], project);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const CreateIssueScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
}
