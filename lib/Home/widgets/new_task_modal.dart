import 'package:flutter/material.dart';

class NewTaskModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          Text(
            'New Tally Task',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

// temporary from developer quest

/// This is a simple text header for the tasks list.
class TaskPickerHeader extends SliverPersistentHeaderDelegate {
  final String title;
  final bool showLine;
  const TaskPickerHeader(this.title, {this.showLine = true});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(overflow: Overflow.visible, children: [
      showLine
          ? Positioned.fromRect(
              rect: Rect.fromLTWH(26, 25, 2, 35 - shrinkOffset),
              child: SizedOverflowBox(
                size: const Size.fromHeight(0),
                child: Container(color: treeLineColor),
              ),
            )
          : Container(),
      Row(
        children: <Widget>[
          const SizedBox(width: 15),
          Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(84, 114, 244, 0.25),
                      offset: Offset(0, 10),
                      blurRadius: 10,
                      spreadRadius: 0),
                ],
                borderRadius: BorderRadius.all(Radius.circular(12.5)),
                color: Color.fromRGBO(84, 114, 239, 1),
              ),
              child: const Icon(Icons.keyboard_arrow_down)),
          const SizedBox(width: 15),
          Text(
            title,
            style: buttonTextStyle,
          ),
        ],
      ),
    ]);
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(TaskPickerHeader oldDelegate) {
    return title != oldDelegate.title;
  }
}

const Color treeLineColor = Color.fromRGBO(215, 215, 215, 1);
const Color contentColor = Color.fromRGBO(38, 38, 47, 1);

const TextStyle buttonTextStyle = TextStyle(
  fontFamily: 'MontserratMedium',
  fontSize: 16,
  color: contentColor,
);
