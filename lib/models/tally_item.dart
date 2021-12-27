class TallyItem {
  String name;
  late String id;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  bool isCollection = false;
  int positionInList;

  TallyItem({
    required this.name,
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.positionInList =
        0, // later remove the default, since all new task creation will give a position in list
  }) {
    dateCreated = DateTime.now();
    // id = DateTime.now().toString();
  }
}
