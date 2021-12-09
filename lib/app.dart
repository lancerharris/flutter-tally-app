import 'package:flutter/material.dart';

import 'package:tally_app/theme/app_theme.dart';
import 'main_scaffold.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tally',
      theme: AppTheme.dark(),
      home: MainScaffold(title: 'Tally'),
      debugShowCheckedModeBanner: false,
    );
  }
}
