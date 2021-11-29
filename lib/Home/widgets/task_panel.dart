import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/tally_item.dart';
import '../../models/tally_task.dart';
import '../../widgets/scratch_box/scratch_box.dart';
import '../../widgets/new_reorderable_list.dart';
import '../../providers/task_manager.dart';
import '../../theme/app_theme.dart';

class TaskPanel extends StatelessWidget {
  const TaskPanel({Key? key, required this.listItem, this.childListItems})
      : super(key: key);
  final TallyItem listItem;
  final List<TallyTask>? childListItems;

  @override
  Widget build(BuildContext context) {
    var isExpanded = listItem.isExpanded;

    void updateChildItemPositions(
        int oldPositionInList, int newPositionInList) {
      Provider.of<TaskManager>(context, listen: false)
          .updateItemPositions(oldPositionInList, newPositionInList, false);
    }

    return GestureDetector(
      child: Card(
        child: Container(
          child: Column(
            children: [
              Card(
                shadowColor: isExpanded ? AppTheme.secondaryColor : null,
                elevation: 2,
                margin: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                                      style:
                                          Theme.of(context).textTheme.headline3,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
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
                    ),
                    if (isExpanded && !listItem.isCollection)
                      ScratchBox(
                        backdropHeight: 100,
                      )
                  ],
                ),
              ),
              if (isExpanded && childListItems != null)
                ReorderableListSizesDiffer(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    for (var i = 0; i < childListItems!.length; i++)
                      TaskPanel(
                        key: ValueKey('$i'),
                        listItem: childListItems![i],
                        childListItems: null,
                      )
                  ],
                  onReorder: updateChildItemPositions,
                ),
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
