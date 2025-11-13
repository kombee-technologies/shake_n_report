import 'package:flutter/material.dart';
import 'package:shake_n_report/src/core/constants/my_constants.dart';
import 'package:shake_n_report/src/data/models/tool_item.dart';

class ToolsSelections extends StatelessWidget {
  const ToolsSelections({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ToolItem> tools = <ToolItem>[
      ToolItem(name: 'Jira', icon: Icons.bug_report),
      ToolItem(name: 'Asana', icon: Icons.task_alt),
      ToolItem(name: 'Notion', icon: Icons.note),
      ToolItem(name: 'ClickUp', icon: Icons.rocket_launch),
      ToolItem(name: 'Trello', icon: Icons.view_kanban),
      ToolItem(name: 'Monday.com', icon: Icons.calendar_today),
      ToolItem(name: 'Basecamp', icon: Icons.work_outline),
      ToolItem(name: 'Wrike', icon: Icons.work),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(MyConstants.selectTools),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              MyConstants.selectToolsBodyt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: tools.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (BuildContext context, int index) {
                  final ToolItem tool = tools[index];
                  return Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(MyConstants.borderRadius),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          tool.icon,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        tool.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
