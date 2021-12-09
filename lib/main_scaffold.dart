import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'package:tally_app/widgets/add_task_button.dart';
import 'package:tally_app/widgets/bottom_nav.dart';

import 'Home/home_screen.dart';

class MainScaffold extends StatefulWidget {
  MainScaffold({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TaskManager()),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [
            AddTaskButton(),
          ],
        ),
        body: HomeScreen(),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
