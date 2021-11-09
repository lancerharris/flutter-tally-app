import 'package:tally_app/Home/models/tally_item.dart';

class TallyCollection extends TallyItem {
  String name;
  late String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  List<String> tallyTaskNames = [];
  bool isCollection = true;

  TallyCollection({
    required this.name,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) : super(
          name: name,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addTallyTaskName(String taskName) {
    tallyTaskNames.add(taskName);
  }
}
