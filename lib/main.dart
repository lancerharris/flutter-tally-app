import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('tally_tasks');
  await Hive.openBox('tally_collections');
  runApp(MyApp());
}
