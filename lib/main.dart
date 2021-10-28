import 'package:flutter/material.dart';
import 'Home/models/tally_collection.dart';
import 'Home/models/tally_panel.dart';
import 'Home/models/tally_task.dart';

void main() {
  runApp(MyApp());
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tally',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Tally'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this, // this SingleTickerProviderStateMixin
    duration: const Duration(seconds: 1),
  );

  // late final Animation<double> animation = CurvedAnimation(
  //   parent: _animationController,
  //   curve: Curves.fastOutSlowIn,
  // )..addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       setState(() {
  //         _animationController.reverse();
  //       });
  //     } else if (status == AnimationStatus.dismissed) {
  //       setState(() {
  //         _animationController.forward();
  //       });
  //     }
  //   });

  late final _extSizeTweenAnimation =
      Tween<double>(begin: 1, end: 1.5).animate(_animationController);
  late final _interiorSizeTweenAnimation =
      Tween<double>(begin: 1, end: 1.5).animate(_animationController);

  static final _exteriorSizeTween = Tween<double>(begin: 0, end: 1);
  static final _interiorSizeTween = Tween<double>(begin: 0, end: 50);
  final List<TallyPanel> _tallyPanelItems = generateTallyItems();

  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      // body: AnimatedCard(animation: animation),
      // body: SizeTransition(
      //   sizeFactor: animation,
      //   axis: Axis.horizontal,
      //   axisAlignment: -1,
      //   child: const Center(
      //     child: FlutterLogo(size: 200.0),
      //   ),
      // ),
      body: _tallyPanelItems.length > 0
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
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              label: '',
              backgroundColor: Colors.purple),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            label: '',
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: '',
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: '',
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
