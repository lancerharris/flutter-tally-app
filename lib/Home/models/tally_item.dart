class TallyItem {
  String name;
  late String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  bool isCollection = false;
  int? positionInList;

  TallyItem({
    required this.name,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  }) {
    dateCreated = DateTime.now();
    id = DateTime.now().toString();
  }
}
