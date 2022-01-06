import './tally_item.dart';
import 'package:hive/hive.dart';

part 'tally_task.g.dart';

@HiveType(typeId: 0)
class TallyTask extends TallyItem {
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
  final bool isCollection = false;
  @HiveField(8)
  int? goalCount;
  @HiveField(9)
  String? goalIncrement;
  @HiveField(10)
  List<String> collectionMemberships = [];
  @HiveField(11)
  bool inCollection = false;

  TallyTask({
    required this.name,
    required final this.dateCreated,
    required this.positionInList,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.goalCount,
    this.goalIncrement,
  }) : super(
          name: name,
          dateCreated: dateCreated,
          positionInList: positionInList,
          streak: streak,
          count: count,
          isExpanded: isExpanded,
          isFrozen: isFrozen,
        );

  void addToCollectionMemberships(String collectionCandidate) {
    collectionMemberships.add(collectionCandidate);
    inCollection = true;
  }

  void addAllToCollectionMemberships(List<String> collectionCandidates) {
    this.collectionMemberships = collectionCandidates;
    inCollection = true;
  }
}
