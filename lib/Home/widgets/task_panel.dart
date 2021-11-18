import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/models/tally_collection.dart';
import 'package:tally_app/Home/models/tally_item.dart';
import 'package:tally_app/Home/models/tally_task.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'package:tally_app/theme/app_theme.dart';

class TaskPanel extends StatelessWidget {
  const TaskPanel({Key? key, required this.listItem, this.childListItems})
      : super(key: key);
  final TallyItem listItem;
  final List<TallyTask>? childListItems;

  @override
  Widget build(BuildContext context) {
    var isExpanded = listItem.isExpanded;

    return GestureDetector(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      listItem.name,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 25,
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              '${NumberFormat("##,###", "en_US").format(listItem.streak)}',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ],
                        ),
                        SizedBox(width: 2),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 25,
                              decoration: BoxDecoration(
                                color: AppTheme.mainColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                                '${NumberFormat("##,###", "en_US").format(listItem.count)}',
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                        SizedBox(width: 2),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 25,
                              decoration: BoxDecoration(
                                color: AppTheme.disabledColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                                '${NumberFormat("##,###", "en_US").format(listItem.count)}',
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 25),
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
                      child: TaskPanel(
                          listItem: childListItems![index],
                          // passing null right now since not allowing 3 level
                          // nesting
                          childListItems: null),
                    );
                    // child: Center(child: Text('Entry $index')));
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount:
                      (listItem as TallyCollection).tallyTaskNames.length,
                )
            ],
          ),
        ),
      ),
      onTap: () {
        Provider.of<TaskManager>(context, listen: false).updateExpansion(
          listItem.id,
          listItem.isCollection,
        );
      },
    );
  }
}
