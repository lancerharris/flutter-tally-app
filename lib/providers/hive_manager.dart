import 'package:hive/hive.dart';
import 'package:tally_app/models/tally_collection.dart';
import 'package:tally_app/models/tally_item.dart';
import 'package:tally_app/models/tally_task.dart';

import '../models/enum_collection_status.dart';

class HiveManager {
  void createTask(TallyTask task) => Hive.box('tally_tasks').add(task);
  void createCollection(TallyCollection collection) =>
      Hive.box('tally_collections').add(collection);

  Future<List<TallyTask>> readTallyTasks() async {
    List<TallyTask> taskList = [];
    final tallyTasks = await Hive.box('tally_tasks');
    for (var i = 0; i < tallyTasks.length; i++) {
      final tallyTask = tallyTasks.getAt(i) as TallyTask;
      taskList.add(tallyTask);
    }
    return taskList;
  }

  Future<List<TallyCollection>> readTallyCollections() async {
    List<TallyCollection> collectionList = [];
    final tallyCollections = await Hive.box('tally_collections');
    for (var i = 0; i < tallyCollections.length; i++) {
      final tallyCollection = tallyCollections.getAt(i) as TallyCollection;
      collectionList.add(tallyCollection);
    }
    return collectionList;
  }

  void updateTask(TallyTask task) => task.save();
  void updateCollection(TallyCollection collection) => collection.save();
}
