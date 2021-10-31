import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/models/tally_collection.dart';
import 'package:tally_app/providers/task_manager.dart';

import 'child_task_panel.dart';

class ParentTaskPanel extends StatefulWidget {
  // final Map<String, dynamic> tallyPanelMap;
  final int index;
  const ParentTaskPanel({required this.index});

  @override
  State<ParentTaskPanel> createState() => _ParentTaskPanelState();
}

class _ParentTaskPanelState extends State<ParentTaskPanel> {
  @override
  Widget build(BuildContext context) {
    var parentListItem =
        Provider.of<TaskManager>(context).getParentItemByIndex(widget.index);

    var isExpanded = parentListItem.isExpanded;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        //height: _exteriorSizeTween.evaluate(animation),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(parentListItem.name),
                GestureDetector(
                  child: isExpanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
                  onTap: () {
                    setState(() {
                      if (parentListItem.isCollection) {
                        Provider.of<TaskManager>(context, listen: false)
                            .updateExpansion(
                                parentListItem.id, parentListItem.isCollection);
                      } else {
                        Provider.of<TaskManager>(context, listen: false)
                            .updateExpansion(
                          parentListItem.id,
                          parentListItem.isCollection,
                        );
                      }

                      // panelListItem.isExpanded = !panelListItem.isExpanded;
                    });
                  },
                ),
              ],
            ),
            if (isExpanded)
              SizedBox(
                height: 10,
              ),
            if (parentListItem.isCollection &&
                isExpanded &&
                (parentListItem as TallyCollection).tallyTaskIds.length > 0)
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10),
                    child: ChildTaskPanel(
                      childItemId: parentListItem.tallyTaskIds[index],
                      // childPanelItem: Provider.of<TallyTasks>(context)
                      //     .getChildPanelById(panelListItem.id, index))
                    ),
                  );
                  // child: Center(child: Text('Entry $index')));
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: parentListItem.tallyTaskIds.length,
              )
          ],
        ),
      ),
    );
  }
}
