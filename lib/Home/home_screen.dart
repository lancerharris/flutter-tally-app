import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/models/tally_collection.dart';
import 'package:tally_app/Home/models/tally_task.dart';
import 'package:tally_app/Home/widgets/task_panel.dart';
import 'package:tally_app/custom_widgets/new_reorderable_list.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'dart:ui';

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
        ? ReorderableListSizesDiffer(
            // ? will proxyDecorator allow a shake effect
            proxyDecorator: _proxyDecorator,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(8),
            children: [
              for (var i = 0; i < parentListItems.length; i++)
                TaskPanel(
                  key: ValueKey('$i'),
                  listItem: parentListItems[i],
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

// right now this is just dictating the animation of the elevation
Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double elevation = lerpDouble(0, 6, animValue)!;
      return Material(
        elevation: elevation,
        child: child,
      );
    },
    child: child,
  );
}
