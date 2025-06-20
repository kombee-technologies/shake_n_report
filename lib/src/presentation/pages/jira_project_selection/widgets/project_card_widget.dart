import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/data/models/jira/response/accessible_resource_response.dart';
import 'package:shake_n_report/src/data/models/jira/response/jira_project_response.dart';
import 'package:shake_n_report/src/presentation/widgets/cache_network_image_widget.dart';
import 'package:shake_n_report/src/presentation/state_management/jira_management_cubit/jira_management_cubit.dart';

class ProjectCardWidget extends StatefulWidget {
  final AccessibleResourcesResponse? project;
  final void Function(ProjectItem? project) onTap;

  const ProjectCardWidget({
    required this.project,
    required this.onTap,
    super.key,
  });

  @override
  State<ProjectCardWidget> createState() => _ProjectCardWidgetState();
}

class _ProjectCardWidgetState extends State<ProjectCardWidget> {
  @override
  Widget build(BuildContext context) {
    final List<String> scopes = widget.project?.scopes ?? <String>[];

    return ExpansionTile(
      initiallyExpanded: widget.project?.projects?.isNotEmpty ?? false,
      maintainState: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MyConstants.borderRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MyConstants.borderRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onExpansionChanged: (bool isExpanded) {
        // Check if projects are empty and id is not null before fetching
        if (isExpanded &&
            (widget.project?.projects?.isEmpty ?? true) &&
            widget.project?.id != null &&
            widget.project?.errorStr == null) {
          context.read<JiraManagementCubit>().getProjectsForResource(widget.project?.id ?? '');
        }
      },
      title: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(MyConstants.borderRadius),
              child: CacheNetworkImageWidget(
                imageUrl: widget.project?.avatarUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.project?.name ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.project?.url ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 3,
                    runSpacing: 2,
                    children: scopes
                        .map<Widget>(
                          (String scope) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            child: Text(
                              scope,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      children: <Widget>[
        ((widget.project?.projects?.isEmpty ?? true) && widget.project?.errorStr == null)
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CupertinoActivityIndicator(),
              )
            : (widget.project?.errorStr != null)
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(widget.project?.errorStr ?? ''),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(MyConstants.borderRadius),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) => InkWell(
                        borderRadius: BorderRadius.circular(MyConstants.borderRadius),
                        onTap: () {
                          widget.onTap(widget.project?.projects?[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              CacheNetworkImageWidget(
                                imageUrl: widget.project?.projects?[index].avatarUrls?.the48X48 ?? '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  widget.project?.projects?[index].name ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemCount: widget.project?.projects?.length ?? 0,
                    ),
                  ),
      ],
    );
  }
}
