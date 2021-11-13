import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/models/tally_collection.dart';
import 'package:tally_app/Home/models/tally_item.dart';
import 'package:tally_app/Home/models/tally_task.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'child_task_panel.dart';

class ParentTaskPanel extends StatelessWidget {
  const ParentTaskPanel(
      {Key? key, required this.parentListItem, this.childListItems})
      : super(key: key);
  final TallyItem parentListItem;
  final List<TallyTask>? childListItems;

  @override
  Widget build(BuildContext context) {
    var isExpanded = parentListItem.isExpanded;

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
                    parentListItem.name,
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
              if (isExpanded && childListItems != null)
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10),
                      child: ChildTaskPanel(
                        childItem: childListItems![index],
                      ),
                    );
                    // child: Center(child: Text('Entry $index')));
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount:
                      (parentListItem as TallyCollection).tallyTaskNames.length,
                )
            ],
          ),
        ),
      ),
      onTap: () {
        Provider.of<TaskManager>(context, listen: false)
            .updateExpansion(parentListItem.id, parentListItem.isCollection);
      },
    );
  }
}
