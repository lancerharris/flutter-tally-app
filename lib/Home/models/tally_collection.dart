import 'package:tally_app/Home/models/tally_item.dart';

class TallyCollection extends TallyItem {
  String name;
  String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  List<String> tallyTaskIds = [];
  bool isCollection = true;

  TallyCollection({
    required this.name,
    required this.id,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) : super(
          name: name,
          id: id,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addTallyTaskId(String tallyTaskId) {
    tallyTaskIds.add(tallyTaskId);
  }
}
