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
  const TaskPanel({
    Key? key,
    required this.listItem,
    this.childListItems,
  }) : super(key: key);
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
        child: Column(
          children: [
            Card(
              color: listItem.isCollection ? null : AppTheme.secondaryCardColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: !isExpanded
                    ? BorderRadius.circular(4)
                    : BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
              ),
              margin: EdgeInsets.all(0),
              child: Padding(
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
              ),
            ),
            if (isExpanded && !listItem.isCollection)
              ScratchBox(
                itemId: listItem.id,
                backdropHeight: 100,
              ),
            if (isExpanded && childListItems != null) SizedBox(height: 5),
            if (isExpanded && childListItems != null)
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: ReorderableListSizesDiffer(
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
              ),
            if (isExpanded && childListItems != null) SizedBox(height: 5),
          ],
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
