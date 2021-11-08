import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:tally_app/theme/app_theme.dart';

class NewTaskModal extends StatefulWidget {
  NewTaskModal(this.collectionNames);
  List<String> collectionNames;

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  var _addGoal = true;
  List<ListWheelItem> _wheelValues = [];
  Map<String, bool> collectionMap = {};
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  // var textField1Focus = false;
  // var textField2Focus = false;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    // _focusNode1.addListener(() {
    //   textField1Focus = _focusNode1.hasFocus ? true : false;
    // });
    // _focusNode2.addListener(() {
    //   textField2Focus = _focusNode2.hasFocus ? true : false;
    // });
  }

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

    if (collectionMap.isEmpty) {
      widget.collectionNames.forEach((name) {
        collectionMap[name] = false;
      });
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
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      focusNode: _focusNode1,
                      cursorColor: Color.lerp(
                          AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.lerp(AppTheme.mainColor,
                                  AppTheme.secondaryColor, 0.05)!),
                        ),
                        labelText: 'i.e. Do something exciting',
                        labelStyle: TextStyle(
                          color: _focusNode1.hasFocus
                              ? Color.lerp(AppTheme.mainColor,
                                  AppTheme.secondaryColor, 0.05)
                              : null,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(_focusNode1);
                        });
                      },
                    )
                    // child: ClipRRect(
                    //   borderRadius: BorderRadius.circular(25),
                    //   child: Container(
                    //     padding: EdgeInsets.only(
                    //         top: 5, right: 10, bottom: 5, left: 10),
                    //     color: Color.lerp(
                    //         AppTheme.mainColor, AppTheme.secondaryColor, 0.05),

                    //     child: Text(
                    //         'show a chip shaped text input with inner text \'I.e. Do something exciting\''),
                    //   ),
                    // ),
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
                          Row(children: [
                            Text('(',
                                textScaleFactor: 2,
                                style: Theme.of(context).textTheme.headline2),
                            SizedBox(width: 10),
                            SizedBox(
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
                          SizedBox(width: 15)
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
                Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: widget.collectionNames
                          .map((name) {
                            return GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 5, right: 10, bottom: 5, left: 10),
                                  color: collectionMap[name] == true
                                      ? Color.lerp(AppTheme.mainColor,
                                          AppTheme.secondaryColor, 0.05)
                                      : AppTheme.disabledColor,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        '$name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      SizedBox(width: 10),
                                      if (collectionMap[name] == true)
                                        Icon(
                                          Icons.close_rounded,
                                          size: 16,
                                        )
                                      else
                                        Icon(
                                          Icons.add,
                                          size: 16,
                                        )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (collectionMap[name] != null) {
                                    collectionMap[name] = !collectionMap[name]!;
                                  }
                                });
                              },
                            );
                            // return InputChip(
                            //     elevation: 2,
                            //     label: Text('$name'),

                            //     onPressed: () {
                            //       print('${widget.collectionNames.length}');
                            //     });
                          })
                          .toList()
                          .cast<Widget>(),
                    )
                    // child: GridView.builder(

                    //     shrinkWrap: true,
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 3),
                    //     itemCount: widget.collectionNames.length,
                    //     itemBuilder: (_, index) {
                    //       return InputChip(

                    //           avatar: CircleAvatar(
                    //             backgroundColor: Colors.grey.shade800,
                    //             child: const Text('AB'),
                    //           ),
                    //           label: const Text('Aaron Burr'),
                    //           onPressed: () {
                    //             print('${widget.collectionNames.length}');
                    //           });
                    //     })
                    // child: Text(
                    //     'show Chips here to correspond to collections. they should wrap'),
                    ),
                SizedBox(height: 20),
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
                  child: TextField(
                    focusNode: _focusNode2,
                    cursorColor: Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.lerp(AppTheme.mainColor,
                                AppTheme.secondaryColor, 0.05)!),
                      ),
                      labelText: 'i.e. Workouts',
                      labelStyle: TextStyle(
                        color: _focusNode2.hasFocus
                            ? Color.lerp(AppTheme.mainColor,
                                AppTheme.secondaryColor, 0.05)
                            : null,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(_focusNode2);
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cancel button'),
                    SizedBox(width: 10),
                    Text('Submit button')
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
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
