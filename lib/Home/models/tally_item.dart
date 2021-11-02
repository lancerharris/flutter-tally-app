class TallyItem {
  String name;
  String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  bool isCollection = false;
  int? positionInList;

  TallyItem({
    required this.name,
    required this.id,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) : dateCreated = DateTime.now();
}
