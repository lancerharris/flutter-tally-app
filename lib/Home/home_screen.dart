import 'package:flutter/material.dart';

import 'models/tally_collection.dart';
import 'models/tally_panel.dart';
import 'models/tally_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TallyPanel> _tallyPanelItems = generateTallyItems();

  @override
  Widget build(BuildContext context) {
    return _tallyPanelItems.length > 0
        ? ListView.separated(
            padding: EdgeInsets.all(8),
            itemCount: _tallyPanelItems.length,
            itemBuilder: (context, index) {
              var isExpanded = _tallyPanelItems[index].isExpanded;

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
                          Text(_tallyPanelItems[index].name),
                          GestureDetector(
                            child: isExpanded
                                ? Icon(Icons.expand_less)
                                : Icon(Icons.expand_more),
                            onTap: () {
                              setState(() {
                                _tallyPanelItems[index].isExpanded =
                                    !_tallyPanelItems[index].isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      if (isExpanded)
                        Container(
                          color: Colors.red,
                          child: Card(
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, index) => SizedBox(
              height: 5,
            ),
          )
        : const Center(
            child: Text('Start adding tally tasks!'),
          );
  }
}

List<TallyPanel> generateTallyItems() {
  var tallyTask1 = TallyTask("Eat Breakfast",
      isExpanded: false, streak: 4, isFrozen: false, count: 15);
  var tallyTask2 = TallyTask("task_2",
      isExpanded: false, streak: 3, isFrozen: false, count: 4);
  var tallyTask3 = TallyTask("task_3",
      isExpanded: false, streak: 7, isFrozen: false, count: 99);
  var tallyCollection1 = TallyCollection("first collection",
      count: 10, isExpanded: false, isFrozen: false, streak: 10);

  tallyCollection1.addTallyTask(tallyTask2);
  tallyCollection1.addTallyTask(tallyTask3);

  List<TallyPanel> tallyPanelItems = [];
  tallyPanelItems.add(TallyPanel(
    tallyTask1.name,
    count: tallyTask1.count,
    isExpanded: tallyTask1.isExpanded,
    isFrozen: tallyTask1.isFrozen,
    streak: tallyTask1.streak,
  ));
  tallyPanelItems.add(TallyPanel(
    tallyTask2.name,
    count: tallyTask2.count,
    isExpanded: tallyTask2.isExpanded,
    isFrozen: tallyTask2.isFrozen,
    streak: tallyTask2.streak,
  ));
  tallyPanelItems.add(TallyPanel(
    tallyCollection1.name,
    count: tallyCollection1.count,
    isExpanded: tallyCollection1.isExpanded,
    isFrozen: tallyCollection1.isFrozen,
    streak: tallyCollection1.streak,
  ));

  return tallyPanelItems;
}
