import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'models/tally_collection.dart';
import 'models/tally_task.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TallyTaskAdapter());
  Hive.registerAdapter(TallyCollectionAdapter());
  await Hive.openBox('tally_tasks');
  await Hive.openBox('tally_collections');
  runApp(MyApp());
}
