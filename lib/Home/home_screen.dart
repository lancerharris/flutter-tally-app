import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/models/tally_collection.dart';
import 'package:tally_app/Home/models/tally_task.dart';
import 'package:tally_app/Home/widgets/parent_task_panel.dart';
import 'package:tally_app/providers/task_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void updateParentItemPositions(
        int oldPositionInList, int newPositionInList) {
      Provider.of<TaskManager>(context, listen: false)
          .updateItemPositions(oldPositionInList, newPositionInList, true);
    }

    List<TallyTask> getChildListItems(List<String> childNames) {
      List<TallyTask> childTasks = [];
      childNames.forEach((name) {
        var childItem = Provider.of<TaskManager>(context, listen: false)
            .getChildItemByName(name);
        childTasks.add(childItem);
      });
      return childTasks;
    }

    var parentListItems = Provider.of<TaskManager>(context).parentItemList;
    return parentListItems.length > 0
        ? ReorderableListView(
            padding: EdgeInsets.all(8),
            children: [
              for (var i = 0; i < parentListItems.length; i++)
                ParentTaskPanel(
                  key: ValueKey('$i'),
                  parentListItem: parentListItems[i],
                  childListItems: parentListItems[i].isCollection
                      ? getChildListItems(
                          (parentListItems[i] as TallyCollection)
                              .tallyTaskNames)
                      : null,
                ),
            ],
            onReorder: (oldPositionInList, newPositionInList) {
              updateParentItemPositions(oldPositionInList, newPositionInList);
            })
        : const Center(
            child: Text('Start adding tally tasks!'),
          );
  }
}
