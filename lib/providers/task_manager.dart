import 'package:flutter/foundation.dart';
import 'package:tally_app/Home/models/tally_item.dart';
import '../Home/models/tally_collection.dart';
import '../Home/models/tally_task.dart';

class TaskManager with ChangeNotifier {
  List<TallyItem> _topLevelList = [];
  List<TallyItem> _parentItemList = [];
  List<TallyTask> _childItemList = [];

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
    "tallyCollection2": {
      "name": "second collection",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection3": {
      "name": "third",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection4": {
      "name": "fourth",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection5": {
      "name": "fifth",
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
          count: value["count"],
          isExpanded: value["isExpanded"],
          isFrozen: value["isFrozen"],
          streak: value["streak"],
        );
        _topLevelList.add(currentCollection);
      },
    );

    // some initialization of mock data. could have hard coded the result
    addTaskToCollection("task_2", "first collection");
    addTaskToCollection("task_3", "first collection");

    createParentItemList();
    createChildItemList();
  }

  void updateExpansion(String id, bool isCollection) {
    // choosing not to update initial data
    var itemToUpdate = _topLevelList.firstWhere(
        (item) => item.id == id && item.isCollection == isCollection);

    itemToUpdate.isExpanded = !itemToUpdate.isExpanded;
    // update _topLevelList
    updateTopLevelList(itemToUpdate.name, isCollection, itemToUpdate, true);

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

  List<TallyTask> get childItemList {
    return [..._childItemList];
  }

  List<String> get taskNames {
    List<String> taskNames = [];
    _topLevelList.forEach((item) {
      if (!item.isCollection) {
        taskNames.add(item.name);
      }
    });
    return taskNames;
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

  List<String> get collectionNames {
    List<String> collectionNames = [];
    _topLevelList.forEach((element) {
      if (element.isCollection) {
        collectionNames.add(element.name);
      }
    });
    return collectionNames;
  }

  TallyItem getParentItemByIndex(int itemIndex) {
    return _parentItemList[itemIndex];
  }

  TallyItem getChildItemByName(String itemName) {
    return _childItemList.firstWhere((item) => item.name == itemName);
  }

  void updateTopLevelList(String name, bool isCollection, TallyItem item,
      [bool snubListeners = false]) {
    var replacementIndex = _topLevelList.indexWhere(
        (item) => item.name == name && item.isCollection == isCollection);

    _topLevelList.replaceRange(replacementIndex, replacementIndex + 1, [item]);
    if (!snubListeners) {
      notifyListeners();
    }
  }

  void addTask(TallyTask task) {
    _topLevelList.add(task);
    if (task.inCollection) {
      _childItemList.add(task);

      // add the new collection
      String? newCollectionName;
      for (var i = 0; i < task.collectionMemberships.length; i++) {
        if (!collectionNames.contains(task.collectionMemberships[i])) {
          newCollectionName = task.collectionMemberships[i];
          // There will only be one new collection per task creation by design.
          break;
        }
      }

      if (newCollectionName != null) {
        addCollection(TallyCollection(name: newCollectionName));
      }

      // add as child to all collection memberships
      task.collectionMemberships.forEach((collectionName) {
        updateColletionTaskMembers(task.name, collectionName);
      });
    } else {
      _parentItemList.add(task);
      // only notify if not in collection. otherwise wait for collection add.
      notifyListeners();
    }

    // TODO (LH): Save to back end
  }

  void addCollection(TallyCollection collection) {
    _topLevelList.add(collection);
    // add to parent since can't be child by design.
    _parentItemList.add(collection);
    notifyListeners();
    // TODO (LH): Save to back end
  }

  void addTaskToCollection(String taskName, String collectionName) {
    var itemToUpdate = _topLevelList
        .firstWhere((item) => item.name == taskName && !item.isCollection);
    (itemToUpdate as TallyTask).addToCollectionMemberships(collectionName);

    var collectionToUpdate = _topLevelList
        .firstWhere((item) => item.name == collectionName && item.isCollection);
    (collectionToUpdate as TallyCollection).addTallyTaskName(taskName);

    // only notify listeners on last call
    updateTopLevelList(taskName, false, itemToUpdate, true);
    updateTopLevelList(collectionName, true, collectionToUpdate, true);
    createParentItemList(true);
    createChildItemList();
  }

  void updateColletionTaskMembers(String taskName, String collectionName) {
    var collectionToUpdate = _topLevelList
        .firstWhere((item) => item.name == collectionName && item.isCollection);
    (collectionToUpdate as TallyCollection).addTallyTaskName(taskName);
    notifyListeners();
  }
}
