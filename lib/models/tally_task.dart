import 'package:tally_app/models/collection_identifier.dart';

import './tally_item.dart';

class TallyTask extends TallyItem {
  String name;
  String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  bool isCollection = false;
  late DateTime dateCreated;
  int? goalCount;
  String? goalIncrement;
  List<CollectionIdentifier> collectionMemberships = [];
  bool inCollection = false;

  TallyTask({
    required this.id,
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

  void addToCollectionMemberships(CollectionIdentifier collectionCandidate) {
    collectionMemberships.add(collectionCandidate);
    inCollection = true;
  }

  void addAllToCollectionMemberships(
      List<CollectionIdentifier> collectionCandidates) {
    this.collectionMemberships = collectionCandidates;
    inCollection = true;
  }
}
