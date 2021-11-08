import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({Key? key}) : super(key: key);

  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  var _addGoal = true;
  List<ListWheelItem> _wheelValues = [];

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
                        style: Theme.of(context).textTheme.headline3,
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
                          style: Theme.of(context).textTheme.headline3),
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
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('I want to get',
                    style: Theme.of(context).textTheme.headline2),
                SizedBox(width: 10),
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
                        Text(
                          'N',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
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
                        offAxisFraction: -0.2,
                        itemExtent: 35,
                        physics: BouncingScrollPhysics(),
                        children: _wheelValues),
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
