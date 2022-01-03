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
  int streak;
  @HiveField(3)
  int count;
  @HiveField(4)
  bool isExpanded;
  @HiveField(5)
  bool isFrozen;
  @HiveField(6)
  final bool isCollection = false;
  @HiveField(7)
  int? goalCount;
  @HiveField(8)
  String? goalIncrement;
  @HiveField(9)
  List<String> collectionMemberships = [];
  @HiveField(10)
  bool inCollection = false;

  TallyTask({
    required this.name,
    required final this.dateCreated,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.goalCount,
    this.goalIncrement,
  }) : super(
          name: name,
          dateCreated: dateCreated,
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
