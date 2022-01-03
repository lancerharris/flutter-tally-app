import 'package:flutter/material.dart';

import './add_goal.dart';
import './complete_task_creation.dart';
import './name_task.dart';
import './select_collection.dart';
import './title_bar.dart';
import '../theme/app_theme.dart';
import '../models/tally_task.dart';

class NewTaskModal extends StatefulWidget {
  const NewTaskModal({Key? key, this.collections, this.taskNames})
      : super(key: key);
  final List<String>? collections;
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

  void addToCollectionMemberships(String parentCollection) {
    if (parentCollection.trim() != '') {
      _collectionMemberships.add(parentCollection);
    } else {
      // if the user removes their text, remove from _collectionMemberships
      if (widget.collections != null) {
        _collectionMemberships.removeWhere((parentCollection) =>
            !widget.collections!.contains(parentCollection));
      }
    }
  }

  void removeFromCollectionMemberships(String collectionName) {
    _collectionMemberships
        .removeWhere((collection) => collection == collectionName);
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
        dateCreated: DateTime.now(),
        goalCount: _goalCount,
        goalIncrement: _goalIncrement,
      );
      if (_collectionMemberships.isNotEmpty) {
        newTallyTask.addAllToCollectionMemberships(_collectionMemberships);
      }
      Navigator.pop(context, newTallyTask);
    } else if (errorExists() || _newTaskName == null) {
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
                    collections: widget.collections,
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
