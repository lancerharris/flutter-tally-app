import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class AddGoal extends StatefulWidget {
  const AddGoal(
      {Key? key, required this.setGoalCount, required this.setGoalIncrement})
      : super(key: key);
  final Function(int?) setGoalCount;
  final Function(String?) setGoalIncrement;

  @override
  _AddGoalState createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  var _addGoal = true;
  var _goalCount = 1;
  var _goalIncrement = 'Daily';
  final addNList = [1, 10, 100, 1000];
  final subtractNList = [-1, -10, -100, -1000];
  final goalIncrements = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
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
                    widget.setGoalCount(_goalCount);
                    widget.setGoalIncrement(_goalIncrement);
                    setState(() {
                      _addGoal = _addGoal ? false : true;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, right: 15, bottom: 5, left: 15),
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
                    widget.setGoalCount(null);
                    widget.setGoalIncrement(null);
                    setState(() {
                      _addGoal = _addGoal ? false : true;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, right: 15, bottom: 5, left: 15),
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
            padding:
                const EdgeInsets.only(left: 15, top: 20, bottom: 15, right: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('I want to get',
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(width: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        // padding: EdgeInsets.only(
                        //     top: 0, right: 10, bottom: 0, left: 6),
                        color: AppTheme.disabledColor,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              child: Column(
                                  children: subtractNList
                                      .map((integer) {
                                        return GestureDetector(
                                          child: PlusNButton(plusNInt: integer),
                                          onTap: () {
                                            widget.setGoalCount(_goalCount);
                                            setState(() {
                                              _goalCount =
                                                  max(1, _goalCount + integer);
                                            });
                                          },
                                        );
                                      })
                                      .toList()
                                      .cast<Widget>()),
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                '${NumberFormat("##,###", "en_US").format(_goalCount)}',
                                style: Theme.of(context).textTheme.headline2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              child: Column(
                                  children: addNList
                                      .map((integer) {
                                        return GestureDetector(
                                          child: PlusNButton(plusNInt: integer),
                                          onTap: () {
                                            widget.setGoalCount(_goalCount);
                                            setState(() {
                                              _goalCount = min(
                                                  _goalCount + integer, 99999);
                                            });
                                          },
                                        );
                                      })
                                      .toList()
                                      .cast<Widget>()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(_goalCount == 1 ? 'Tally' : 'Tallies',
                        style: Theme.of(context).textTheme.headline3),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: goalIncrements.map((increment) {
                    return GestureDetector(
                      child: IncrementButtons(
                        increment: increment,
                        inputColor: _goalIncrement == increment
                            ? Color.lerp(AppTheme.mainColor,
                                AppTheme.secondaryColor, 0.0750)!
                            : AppTheme.disabledColor,
                      ),
                      onTap: () {
                        widget.setGoalIncrement(increment);
                        setState(() {
                          _goalIncrement = increment;
                        });
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        if (!_addGoal) SizedBox(height: 10),
      ],
    );
  }
}

class PlusNButton extends StatelessWidget {
  const PlusNButton({Key? key, required this.plusNInt}) : super(key: key);
  final int plusNInt;
  @override
  Widget build(BuildContext context) {
    var isPositive = plusNInt >= 0;
    var largeAbs = plusNInt.abs() >= 1000;
    var intString = largeAbs
        ? '${(plusNInt / 1000).floor().toString()}k'
        : plusNInt.toString();

    return Container(
      decoration: BoxDecoration(
        color: Color.lerp(AppTheme.mainColor, AppTheme.secondaryColor, 0.0750),
        border: Border(
          bottom: BorderSide(
              color: largeAbs ? Colors.transparent : AppTheme.disabledColor,
              width: 1),
        ),
      ),
      width: 50,
      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
      child: Text(
        isPositive ? '+$intString' : intString,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}

class IncrementButtons extends StatelessWidget {
  const IncrementButtons(
      {Key? key, required this.increment, required this.inputColor})
      : super(key: key);
  final String increment;
  final Color inputColor;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: increment == 'Daily' ? Radius.circular(25) : Radius.zero,
        bottomLeft: increment == 'Daily' ? Radius.circular(25) : Radius.zero,
        topRight: increment == 'Yearly' ? Radius.circular(25) : Radius.zero,
        bottomRight: increment == 'Yearly' ? Radius.circular(25) : Radius.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: inputColor,
          border: Border(
            left: BorderSide(
                color: increment == 'Daily'
                    ? Colors.transparent
                    : AppTheme.disabledColor,
                width: 1),
          ),
        ),
        padding: EdgeInsets.only(top: 5, right: 15, bottom: 5, left: 15),
        child: Text(
          increment,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}
