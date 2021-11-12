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
  const NewTaskModal({Key? key, this.collectionNames, this.taskNames})
      : super(key: key);
  final List<String>? collectionNames;
  final List<String>? taskNames;

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  String? _newTaskName;
  List<String> _collectionMemberships = [];
  int? _goalCount;
  String? _goalIncrement;

  String _taskNameError = '';
  String _collectionSelectionError = '';

  void setTaskName(String taskName) {
    if (taskName.trim() != '') {
      _newTaskName = taskName;
    } else {
      _newTaskName = null;
    }
  }

  void setGoalCount(int? goalCount) {
    _goalCount = goalCount;
  }

  void setGoalIncrement(String? goalIncrement) {
    _goalIncrement = goalIncrement;
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
  }

  void removeFromCollectionMemberships(String collectionName) {
    _collectionMemberships.removeWhere((name) => name == collectionName);
  }

  void setInputError(String errorKey, String inputError) {
    switch (errorKey) {
      case 'taskNameError':
        _taskNameError = inputError;

        break;
      case 'collectionSelectionError':
        _collectionSelectionError = inputError;
        break;
    }
  }

  bool errorExists() {
    return _taskNameError != '' || _collectionSelectionError != '';
  }

  void completeTaskCreation() {
    if (!errorExists() && _newTaskName != null) {
      var newTallyTask = TallyTask(
        name: _newTaskName!,
        goalCount: _goalCount,
        goalIncrement: _goalIncrement,
      );
      if (_collectionMemberships.isNotEmpty) {
        newTallyTask.addAllCollectionMemberships(_collectionMemberships);
      }
      Navigator.pop(context, newTallyTask);
    } else if (errorExists() || _newTaskName == null) {
      // TODO (LH): Add notification that you need a task name. snackbar maybe.
      final cantCreateMessage = SnackBar(
        content: Text(
          _taskNameError != ''
              ? _taskNameError
              : _collectionSelectionError != ''
                  ? _collectionSelectionError
                  : _newTaskName == null
                      ? 'You need to name your Task'
                      : 'Unknown error occurred',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: AppTheme.secondaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(cantCreateMessage);
    }
  }

  // TODO (LH): for when i remove the cancel button and put an x near the top of modal
  void cancelTaskCreation() {
    // TODO (LH): once I condition on modal closure (an are you sure modal) this will also be for that as well
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Column(
                children: [
                  NameTask(
                      taskNames: widget.taskNames,
                      setTaskNameCallback: setTaskName,
                      setInputError: setInputError),
                  Divider(),
                  AddGoal(
                      setGoalCount: setGoalCount,
                      setGoalIncrement: setGoalIncrement),
                  Divider(),
                  SelectCollection(
                    collectionNames: widget.collectionNames,
                    collectionMemberships: _collectionMemberships,
                    setInputError: setInputError,
                    addToCollectionMemberships: addToCollectionMemberships,
                    removeFromCollectionMemberships:
                        removeFromCollectionMemberships,
                  ),
                  Divider(),
                  CompleteTaskCreation(
                    completeTaskCreation: completeTaskCreation,
                    taskName: _newTaskName,
                    errorExists: errorExists(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
