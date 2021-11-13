import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/models/tally_task.dart';
import 'package:tally_app/providers/task_manager.dart';

class ChildTaskPanel extends StatelessWidget {
  const ChildTaskPanel({Key? key, required this.childItem}) : super(key: key);
  final TallyTask childItem;

  @override
  Widget build(BuildContext context) {
    var isExpanded = childItem.isExpanded;
    return GestureDetector(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    childItem.name,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  isExpanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
                ],
              ),
              if (isExpanded)
                SizedBox(
                  height: 10,
                ),
            ],
          ),
        ),
      ),
      onTap: () {
        Provider.of<TaskManager>(context, listen: false).updateExpansion(
          childItem.id,
          childItem.isCollection,
        );
      },
    );
  }
}
