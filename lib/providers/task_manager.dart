import 'package:flutter/foundation.dart';
import 'package:tally_app/Home/models/tally_item.dart';
import '../Home/models/tally_collection.dart';
import '../Home/models/tally_task.dart';

class TaskManager with ChangeNotifier {
  List<TallyItem> _topLevelList = [];
  List<TallyItem> _parentItemList = [];
  List<TallyItem> _childItemList = [];

  Map<String, dynamic> tallyTasks = {
    "tallyTask1": {
      "name": "Eat Breakfast",
      "isExpanded": false,
      "streak": 4,
      "isFrozen": false,
      "count": 15,
    },
    "tallyTask2": {
      "name": "task_2",
      "isExpanded": false,
      "streak": 3,
      "isFrozen": false,
      "count": 4,
    },
    "tallyTask3": {
      "name": "task_3",
      "isExpanded": false,
      "streak": 7,
      "isFrozen": false,
      "count": 99,
    },
  };

  Map<String, dynamic> tallyCollections = {
    "tallyCollection1": {
      "name": "first collection",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
  };

  TaskManager() {
    tallyTasks.forEach(
      (key, value) {
        var currentTask = TallyTask(
          name: value["name"],
          id: key,
          count: value["count"],
          isExpanded: value["isExpanded"],
          isFrozen: value["isFrozen"],
          streak: value["streak"],
        );
        _topLevelList.add(currentTask);
      },
    );

    tallyCollections.forEach(
      (key, value) {
        var currentCollection = TallyCollection(
          name: value["name"],
          id: key,
          count: value["count"],
          isExpanded: value["isExpanded"],
          isFrozen: value["isFrozen"],
          streak: value["streak"],
        );
        _topLevelList.add(currentCollection);
      },
    );

    // some initialization of mock data. could have hard coded the result
    addTaskToCollection("tallyTask2", "tallyCollection1");
    addTaskToCollection("tallyTask3", "tallyCollection1");

    createParentItemList();
    createChildItemList();
  }

  void updateExpansion(String id, bool isCollection) {
    // choosing not to update initial data
    var itemToUpdate = _topLevelList.firstWhere(
        (item) => item.id == id && item.isCollection == isCollection);
    itemToUpdate.isExpanded = !itemToUpdate.isExpanded;
    // update _topLevelList
    updateTopLevelList(id, isCollection, itemToUpdate, true);

    if (!isCollection && (itemToUpdate as TallyTask).inCollection) {
      // if it exists as a child update the child list
      createChildItemList();
    } else {
      // otherwise its a parent and update the parentList
      createParentItemList();
    }
  }

  int get parentListLength {
    return _parentItemList.length;
  }

  List<TallyItem> get parentItemList {
    return [...parentItemList];
  }

  void createParentItemList([bool snubListeners = false]) {
    // Don't return tasks that are a part of a collection.
    _parentItemList = [];
    for (int i = 0; i < _topLevelList.length; i++) {
      var item = _topLevelList[i];
      if (item.isCollection ||
          (!item.isCollection && !(item as TallyTask).inCollection)) {
        item.positionInList = i;
        _parentItemList.add(item);
      }
    }
    if (!snubListeners) {
      notifyListeners();
    }
  }

  void createChildItemList([bool snubListeners = false]) {
    _childItemList = [];
    for (int i = 0; i < _topLevelList.length; i++) {
      var item = _topLevelList[i];
      if (!item.isCollection && (item as TallyTask).inCollection) {
        item.positionInList = i;
        _childItemList.add(item);
      }
    }

    if (!snubListeners) {
      notifyListeners();
    }
  }

  TallyItem getParentItemByIndex(int itemIndex) {
    return _parentItemList[itemIndex];
  }

  TallyItem getChildItemById(String itemId) {
    return _childItemList.firstWhere((item) => item.id == itemId);
  }

  void updateTopLevelList(String id, bool isCollection, TallyItem item,
      [bool snubListeners = false]) {
    var replacementIndex = _topLevelList.indexWhere(
        (item) => item.id == id && item.isCollection == isCollection);

    _topLevelList.replaceRange(replacementIndex, replacementIndex + 1, [item]);
    if (!snubListeners) {
      notifyListeners();
    }
  }

  void addTaskToCollection(String taskId, String collectionId) {
    var itemToUpdate = _topLevelList
        .firstWhere((item) => item.id == taskId && !item.isCollection);
    (itemToUpdate as TallyTask).addToCollectionList(collectionId);

    var collectionToUpdate = _topLevelList
        .firstWhere((item) => item.id == collectionId && item.isCollection);
    (collectionToUpdate as TallyCollection).addTallyTaskId(taskId);

    // only notify listeners on last call
    updateTopLevelList(taskId, false, itemToUpdate, true);
    updateTopLevelList(collectionId, true, collectionToUpdate, true);
    createParentItemList(true);
    createChildItemList();
  }
}
