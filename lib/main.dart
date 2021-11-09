import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/widgets/new_task_modal.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'package:tally_app/providers/new_task_manager.dart';
import 'package:tally_app/widgets/bottom_nav.dart';
import 'Home/home_screen.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tally',
      theme: AppTheme.dark(),
      home: MyHomePage(title: 'Tally'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TaskManager()),
        ChangeNotifierProvider(create: (ctx) => NewTaskManager())
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [
            AddTask(),
          ],
        ),
        body: HomeScreen(),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}

class AddTask extends StatelessWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
        iconSize: 30,
        onPressed: () async {
          var collectionNames =
              Provider.of<TaskManager>(context, listen: false).collectionNames;
          var newTask = await showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              context: context,
              constraints: BoxConstraints(
                maxHeight: 500,
                maxWidth: 750,
              ),
              builder: (context) =>
                  NewTaskModal(collectionNames: collectionNames));
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}
