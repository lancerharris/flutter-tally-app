class TallyPanel {
  String name;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;

  TallyPanel(
    this.name, {
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
  });
}
