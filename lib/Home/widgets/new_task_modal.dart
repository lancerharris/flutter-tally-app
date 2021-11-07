import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class NewTaskModal extends StatefulWidget {
  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
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

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              color: AppTheme.secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New Tally Task',
                      style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              children: [
                Text(
                  'Name your new Task',
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                      'show a chip shaped text input with inner text \'I.e. Do something exciting\''),
                ),
                SizedBox(height: 10),
                Divider(),
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
                    child: Container(
                      height: 70,
                      width: 100,
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
                              padding: EdgeInsets.only(
                                  top: 0, right: 10, bottom: 0, left: 6),
                              color: Color.lerp(AppTheme.mainColor,
                                  AppTheme.secondaryColor, 0.05),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'N',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('Tallies ',
                              style: Theme.of(context).textTheme.headline2),
                          Expanded(
                            child: ListWheelScrollView(
                                diameterRatio: 0.8,
                                offAxisFraction: -0.2,
                                itemExtent: 35,
                                physics: BouncingScrollPhysics(),
                                children: _wheelValues),
                          ),
                          SizedBox(width: 50)
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Want this in a Collection?',
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Add to existing:',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                      'show Chips here to correspond to collections. they should wrap'),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Or create something new:',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                      'show a chip shaped text input with inner text \'New Collection Name\''),
                ),
              ],
            ),
          ),
        ],
      ),
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
