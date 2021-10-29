import 'package:flutter/material.dart';
import 'package:tally_app/Home/models/tally_panel.dart';
import 'package:tally_app/Home/models/tally_task.dart';

class TallyTaskPanel extends StatefulWidget {
  final TallyPanel tallyPanelItem;
  const TallyTaskPanel({required this.tallyPanelItem});

  @override
  State<TallyTaskPanel> createState() => _TallyTaskPanelState();
}

class _TallyTaskPanelState extends State<TallyTaskPanel> {
  TallyPanel createTallyPanel(TallyTask? task) {
    if (task != null) {
      return TallyPanel(
        task.name,
        count: task.count,
        isExpanded: task.isExpanded,
        isFrozen: task.isFrozen,
        streak: task.streak,
      );
    } else {
      throw Exception("Tally Panel could not be created TallyTask is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    var isExpanded = widget.tallyPanelItem.isExpanded;
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
                Text(widget.tallyPanelItem.name),
                GestureDetector(
                  child: isExpanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
                  onTap: () {
                    setState(() {
                      widget.tallyPanelItem.isExpanded =
                          !widget.tallyPanelItem.isExpanded;
                    });
                  },
                ),
              ],
            ),
            if (isExpanded)
              SizedBox(
                height: 10,
              ),
            if (isExpanded && widget.tallyPanelItem.children.length > 0)
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TallyTaskPanel(
                      tallyPanelItem: createTallyPanel(
                          widget.tallyPanelItem.children[index]),
                    ),
                  );
                  // child: Center(child: Text('Entry $index')));
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: widget.tallyPanelItem.children.length,
              )
          ],
        ),
      ),
    );
  }
}
