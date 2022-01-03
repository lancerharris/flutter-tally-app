import 'package:hive/hive.dart';

import './tally_item.dart';

part 'tally_collection.g.dart';

@HiveType(typeId: 1)
class TallyCollection extends TallyItem {
  @HiveField(0)
  String name;
  @HiveField(1)
  final DateTime dateCreated;
  @HiveField(2)
  int streak;
  @HiveField(3)
  int count;
  @HiveField(4)
  bool isExpanded;
  @HiveField(5)
  bool isFrozen;
  @HiveField(6)
  List<String> tallyTaskNames = [];
  @HiveField(7)
  final bool isCollection = true;

  TallyCollection({
    required this.name,
    required this.dateCreated,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) : super(
          name: name,
          dateCreated: dateCreated,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addTallyTaskName(String taskName) {
    tallyTaskNames.add(taskName);
  }
}
