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
  int positionInList;
  @HiveField(3)
  int streak;
  @HiveField(4)
  int count;
  @HiveField(5)
  bool isExpanded;
  @HiveField(6)
  bool isFrozen;
  @HiveField(7)
  List<String> tallyTaskNames = [];
  @HiveField(8)
  final bool isCollection = true;

  TallyCollection({
    required this.name,
    required this.dateCreated,
    required this.positionInList,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) : super(
          name: name,
          dateCreated: dateCreated,
          positionInList: positionInList,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addTallyTaskName(String taskName) {
    tallyTaskNames.add(taskName);
  }
}
