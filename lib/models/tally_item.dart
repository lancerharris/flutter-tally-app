import 'package:hive/hive.dart';

class TallyItem extends HiveObject {
  String name;
  final DateTime dateCreated;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  bool isCollection = false;
  int positionInList;

  TallyItem({
    required this.name,
    required this.dateCreated,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.positionInList = 0,
  }) {}
}
