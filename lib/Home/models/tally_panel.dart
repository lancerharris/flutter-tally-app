import 'package:tally_app/Home/models/tally_task.dart';

class TallyPanel {
  String name;
  int streak;
  int count;
  bool isExpanded;
  bool isFrozen;
  bool isCollection;
  List<TallyTask?> children;

  TallyPanel(
    this.name, {
    this.streak = 0,
    this.count = 0,
    this.isExpanded = false,
    this.isFrozen = false,
    this.isCollection = false,
    this.children = const [],
  });

  void saveChanges() {
    // TODO
  }
}
