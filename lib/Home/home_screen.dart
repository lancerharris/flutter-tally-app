import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/widgets/parent_task_panel.dart';
import 'package:tally_app/providers/task_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final List<TallyPanel> _tallyPanelItems = generateTallyItems();

  @override
  Widget build(BuildContext context) {
    var parentListLength = Provider.of<TaskManager>(context).parentListLength;

    return parentListLength > 0
        ? ListView.separated(
            padding: EdgeInsets.all(8),
            itemCount: parentListLength,
            itemBuilder: (context, index) {
              return ParentTaskPanel(index: index);
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
