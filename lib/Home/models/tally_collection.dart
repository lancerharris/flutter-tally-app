import './tally_task.dart';

class TallyCollection {
  String name;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  List<TallyTask> tallyTasks = [];

  TallyCollection(
    this.name, {
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) {
    dateCreated = DateTime.now();
  }

  void addTallyTask(TallyTask tallyTask) {
    tallyTasks.add(tallyTask);
    return;
  }
}
