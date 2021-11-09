import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class AddGoal extends StatefulWidget {
  const AddGoal(
      {Key? key, required this.setGoalCount, required this.setGoalIncrement})
      : super(key: key);
  final Function(int) setGoalCount;
  final Function(int) setGoalIncrement;

  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  var _addGoal = true;
  var _goalCount = 1;
  List<Widget> _wheelValues = [];

  @override
  Widget build(BuildContext context) {
    if (_wheelValues.length == 0) {
      _wheelValues = [
        ListWheelItem(title: 'Daily'),
        ListWheelItem(title: 'Weekly'),
        ListWheelItem(title: 'Monthly'),
        ListWheelItem(title: 'Yearly'),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add a Goal?',
              style: Theme.of(context).textTheme.headline2,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _addGoal = _addGoal ? false : true;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, right: 22, bottom: 10, left: 22),
                      color: _addGoal
                          ? Color.lerp(AppTheme.mainColor,
                              AppTheme.secondaryColor, 0.0750)
                          : AppTheme.disabledColor,
                      child: Text(
                        'Yes',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _addGoal = _addGoal ? false : true;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, right: 22, bottom: 10, left: 22),
                      color: _addGoal
                          ? AppTheme.disabledColor
                          : Color.lerp(AppTheme.mainColor,
                              AppTheme.secondaryColor, 0.05),
                      child: Text('No',
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ),
                ),
                SizedBox(width: 25)
              ],
            ),
          ],
        ),
        if (_addGoal)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('I want to get',
                    style: Theme.of(context).textTheme.headline2),
                SizedBox(width: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 35,
                    width: 35,
                    padding:
                        EdgeInsets.only(top: 0, right: 10, bottom: 0, left: 6),
                    color: Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '$_goalCount',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          onTap: () {
                            _goalCount = 1;
                            widget.setGoalCount(10);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('Tallies ', style: Theme.of(context).textTheme.headline2),
                Row(children: [
                  Text('(',
                      textScaleFactor: 2,
                      style: Theme.of(context).textTheme.headline2),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 70,
                    width: 85,
                    child: ListWheelScrollView(
                      diameterRatio: 0.8,
                      offAxisFraction: -.5,
                      itemExtent: 35,
                      physics: BouncingScrollPhysics(),
                      children: _wheelValues,
                      onSelectedItemChanged: widget.setGoalIncrement,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(')',
                      textScaleFactor: 2,
                      style: Theme.of(context).textTheme.headline2),
                ]),
                SizedBox(width: 10)
              ],
            ),
          ),
        if (!_addGoal) SizedBox(height: 10),
      ],
    );
  }
}

class ListWheelItem extends StatelessWidget {
  const ListWheelItem({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 85,
        padding: EdgeInsets.only(right: 10, left: 10),
        color: Color.lerp(AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
      ),
    );
  }
}
