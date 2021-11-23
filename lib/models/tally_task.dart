import './tally_item.dart';

class TallyTask extends TallyItem {
  String name;
  late String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  bool isCollection = false;
  late DateTime dateCreated;
  int? goalCount;
  String? goalIncrement;
  List<String> collectionMemberships = [];
  bool inCollection = false;

  TallyTask({
    required this.name,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.goalCount,
    this.goalIncrement,
  }) : super(
          name: name,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addToCollectionMemberships(String collectionName) {
    collectionMemberships.add(collectionName);
    inCollection = true;
  }

  void addAllCollectionMemberships(List<String> collectionMemberships) {
    this.collectionMemberships = collectionMemberships;
    inCollection = true;
  }
}
