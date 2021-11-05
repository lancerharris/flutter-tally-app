import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/Home/widgets/new_task_modal.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'package:tally_app/widgets/bottom_nav.dart';
import 'Home/home_screen.dart';

void main() {
  runApp(MyApp());
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TaskManager()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).primaryColorDark,
          actions: [
            IconButton(
                onPressed: () async {
                  showModalBottomSheet(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      context: context,
                      constraints: BoxConstraints(
                        maxWidth: 750,
                      ),
                      builder: (context) => NewTaskModal());
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: HomeScreen(),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
