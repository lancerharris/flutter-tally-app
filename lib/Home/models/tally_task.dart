import 'package:tally_app/Home/models/tally_item.dart';

class TallyTask extends TallyItem {
  String name;
  String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  bool isCollection = false;
  late DateTime dateCreated;
  String goalIncrement;
  List<String> collectionMemberships = [];
  bool inCollection = false;

  TallyTask({
    required this.name,
    required this.id,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.goalIncrement = 'daily',
  }) : super(
          name: name,
          id: id,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addToCollectionList(String collectionId) {
    collectionMemberships.add(collectionId);
    inCollection = true;
  }
}
