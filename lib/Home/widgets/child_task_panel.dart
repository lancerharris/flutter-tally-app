import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tally_app/providers/task_manager.dart';

class ChildTaskPanel extends StatefulWidget {
  // final Map<String, dynamic> tallyPanelMap;
  // final TallyPanel childPanelItem;
  final String childItemId;

  const ChildTaskPanel({required this.childItemId});

  @override
  State<ChildTaskPanel> createState() => _ChildTaskPanelState();
}

class _ChildTaskPanelState extends State<ChildTaskPanel> {
  @override
  Widget build(BuildContext context) {
    var childPanelItem =
        Provider.of<TaskManager>(context).getChildItemById(widget.childItemId);
    var isExpanded = childPanelItem.isExpanded;
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
                Text(childPanelItem.name),
                GestureDetector(
                  child: isExpanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
                  onTap: () {
                    setState(() {
                      print('expand button is working');
                      Provider.of<TaskManager>(context, listen: false)
                          .updateExpansion(
                        childPanelItem.id,
                        childPanelItem.isCollection,
                      );
                    });
                  },
                ),
              ],
            ),
            if (isExpanded)
              SizedBox(
                height: 10,
              ),
          ],
        ),
      ),
    );
  }
}
