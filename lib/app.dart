import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/providers/task_manager.dart';

import 'package:tally_app/theme/app_theme.dart';
import 'main_scaffold.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TaskManager()),
      ],
      child: MaterialApp(
        title: 'Tally',
        theme: AppTheme.dark(),
        home: MainScaffold(title: 'Tally'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
