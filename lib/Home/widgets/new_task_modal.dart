import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:tally_app/Home/widgets/add_goal.dart';
import 'package:tally_app/Home/widgets/complete_task_creation.dart';
import 'package:tally_app/Home/widgets/name_task.dart';
import 'package:tally_app/Home/widgets/select_collection.dart';
import 'package:tally_app/Home/widgets/title_bar.dart';
import 'package:tally_app/theme/app_theme.dart';
import '../models/tally_task.dart';

class NewTaskModal extends StatefulWidget {
  const NewTaskModal({Key? key, this.collectionNames}) : super(key: key);
  final List<String>? collectionNames;

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  String? _newTaskName;
  List<String> _collectionMemberships = [];
  int? _goalCount;
  String? _goalIncrement;

  void setTaskName(String taskName) {
    if (taskName.trim() != '') {
      _newTaskName = taskName;
    } else {
      _newTaskName = null;
    }
  }

  void setGoalCount(int goalCount) {
    _goalCount = goalCount;
    print('goalcount set to $_goalCount');
  }

  void setGoalIncrement(int goalIncrement) {
    switch (goalIncrement) {
      case 0:
        _goalIncrement = 'Daily';
        break;
      case 1:
        _goalIncrement = 'Weekly';
        break;
      case 2:
        _goalIncrement = 'Monthly';
        break;
      case 3:
        _goalIncrement = 'Yearly';
        break;
      default:
        _goalIncrement = null;
    }
    print('setting goal increment to $_goalIncrement');
  }

  void addToCollectionMemberships(String collectionName) {
    if (collectionName.trim() != '') {
      _collectionMemberships.add(collectionName);
    } else {
      // if the user removes their text, remove from _collectionMemberships
      if (widget.collectionNames != null) {
        _collectionMemberships
            .removeWhere((name) => !widget.collectionNames!.contains(name));
      }
    }
    print(_collectionMemberships);
  }

  void removeFromCollectionMemberships(String collectionName) {
    _collectionMemberships.removeWhere((name) => name == collectionName);
    print(_collectionMemberships);
  }

  void completeTaskCreation(bool createNewTask) {
    if (_newTaskName != null && createNewTask) {
      var newTallyTask = TallyTask(
        name: _newTaskName!,
        goalCount: _goalCount,
        goalIncrement: _goalIncrement,
      );
      if (_collectionMemberships.isNotEmpty) {
        // _collectionMemberships.forEach((name) {
        //   tallyTask.addToCollectionMemberships(name);
        // });
        newTallyTask.addAllCollectionMemberships(_collectionMemberships);
      }
      print('returning tally task');
      Navigator.pop(context, newTallyTask);
    } else if (_newTaskName == null && createNewTask) {
      // TODO (LH): Add notification that you need a task name. snackbar maybe.
      final cantCreateMessage = SnackBar(
        
        content: Text(
          'You need to name your Task',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: AppTheme.secondaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(cantCreateMessage);
    }
    // cancel button was pressed
    // TODO (LH): once I condition on modal closure (an are you sure modal) this will also be for that as well
    if (!createNewTask) {
      print('canceling creation');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(right: 15, left: 15),
              children: [
                NameTask(setTaskNameCallback: setTaskName),
                Divider(),
                AddGoal(
                    setGoalCount: setGoalCount,
                    setGoalIncrement: setGoalIncrement),
                Divider(),
                SelectCollection(
                  collectionNames: widget.collectionNames,
                  addToCollectionMemberships: addToCollectionMemberships,
                  removeFromCollectionMemberships:
                      removeFromCollectionMemberships,
                ),
                Divider(),
                CompleteTaskCreation(
                  completeTaskCreation: completeTaskCreation,
                  taskName: _newTaskName,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
