class TallyTask {
  String name;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  late DateTime dateCreated;
  String goalIncrement;

  TallyTask(
    this.name, {
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.goalIncrement = 'daily',
  }) {
    dateCreated = DateTime.now();
  }
}
