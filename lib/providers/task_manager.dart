import 'package:flutter/foundation.dart';
import 'package:tally_app/models/collection_identifier.dart';
import '../models/tally_item.dart';
import '../models/tally_collection.dart';
import '../models/tally_task.dart';

class TaskManager with ChangeNotifier {
  List<TallyItem> _topLevelList = [];
  List<TallyItem> _parentItemList = [];
  List<TallyTask> _childItemList = [];

  Map<String, dynamic> tallyTasks = {
    "tallyTask1": {
      "id": "tt1",
      "name": "Eat Breakfast",
      "isExpanded": false,
      "streak": 4,
      "isFrozen": false,
      "count": 15,
    },
    "tallyTask2": {
      "id": "tt2",
      "name": "task_2",
      "isExpanded": false,
      "streak": 3,
      "isFrozen": false,
      "count": 4,
    },
    "tallyTask3": {
      "id": "tt3",
      "name": "task_3",
      "isExpanded": false,
      "streak": 7,
      "isFrozen": false,
      "count": 99,
    },
  };

  Map<String, dynamic> tallyCollections = {
    "tallyCollection1": {
      "id": 'fc1',
      "name": "first collection",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection2": {
      "id": 'sc1',
      "name": "second collection",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection3": {
      "id": 'tc1',
      "name": "third",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection4": {
      "id": 'fc2',
      "name": "fourth",
      "count": 10,
      "isExpanded": false,
      "isFrozen": false,
      "streak": 10,
    },
    "tallyCollection5": {
      "id": 'fc3',
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
          id: value["id"],
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
          id: value["id"],
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
    updateTaskCollectionMemberships(
      "task_2",
      CollectionIdentifier(id: "fc1", name: "first collection"),
    );
    updateTaskCollectionMemberships(
      "task_3",
      CollectionIdentifier(id: "fc1", name: "first collection"),
    );
    updateColletionTaskMembers(
      "task_2",
      CollectionIdentifier(id: "fc1", name: "first collection"),
    );
    updateColletionTaskMembers(
      "task_3",
      CollectionIdentifier(id: "fc1", name: "first collection"),
    );

    createParentItemList();
    createChildItemList();
  }

  TallyItem fetchItemToUpdate(String id, bool isCollection) {
    // choosing not to update initial mock data
    return _topLevelList.firstWhere(
        (item) => item.id == id && item.isCollection == isCollection);
  }

  void updateExpansion(String id, bool isCollection) {
    var tallyItem = fetchItemToUpdate(id, isCollection);

    tallyItem.isExpanded = !tallyItem.isExpanded;
    notifyListeners();
  }

  void updateCount(String id, bool isCollection) {
    var tallyItem = fetchItemToUpdate(id, isCollection) as TallyTask;
    tallyItem.count += 1;

    if (!isCollection) {
      var collections = tallyItem.collectionMemberships;
      collections.forEach((collection) {
        var collectionToUpdate = fetchItemToUpdate(collection.id, true);
        collectionToUpdate.count += 1;
        print(collectionToUpdate);
      });
    }
    notifyListeners();
  }

  int get parentListLength {
    return _parentItemList.length;
  }

  List<TallyItem> get parentItemList {
    return [..._parentItemList];
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
    var j = 0; // TODO: Remove when positionInList is set on task creation
    for (int i = 0; i < _topLevelList.length; i++) {
      var item = _topLevelList[i];
      if (item.isCollection ||
          (!item.isCollection && !(item as TallyTask).inCollection)) {
        // TODO: remove when positionInList is set on task creation
        item.positionInList = j;
        j++;
        _parentItemList.add(item);
      }
    }

    _parentItemList.sort((a, b) => a.positionInList < b.positionInList
        ? -1
        : a.positionInList == b.positionInList
            ? 0
            : 1);
    if (!snubListeners) {
      notifyListeners();
    }
  }

  // ? maybe this would get expensive with many collections or tasks
  // ? instead of updating many collections maybe I could update a single map
  // ? that holds info with task names as keys and positions as values.
  // ? that way there may be less writes to db or whatever
  void updateItemPositions(
      int oldPositionInList, int newPositionInList, bool isParentList) {
    final operableList = isParentList ? _parentItemList : _childItemList;
    final item = operableList.removeAt(oldPositionInList);

    if (newPositionInList < oldPositionInList) {
      item.positionInList = newPositionInList;
      operableList.insert(newPositionInList, item);

      for (var i = newPositionInList + 1; i <= oldPositionInList; i++) {
        operableList[i].positionInList += 1;
      }
    } else if (newPositionInList > oldPositionInList) {
      item.positionInList = newPositionInList - 1;
      operableList.insert(newPositionInList - 1, item);

      for (var i = oldPositionInList; i < newPositionInList - 1; i++) {
        operableList[i].positionInList -= 1;
      }
    }
    notifyListeners();
  }

  void createChildItemList([bool snubListeners = false]) {
    _childItemList = [];
    for (int i = 0; i < _topLevelList.length; i++) {
      var item = _topLevelList[i];
      if (!item.isCollection && (item as TallyTask).inCollection) {
        // TODO: remove when positionInList is set on task creation
        item.positionInList = i;
        _childItemList.add(item);
      }
    }

    _childItemList.sort((a, b) => a.positionInList < b.positionInList
        ? -1
        : a.positionInList == b.positionInList
            ? 0
            : 1);

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

  List<CollectionIdentifier> get CollectionIdentifiers {
    List<CollectionIdentifier> collectionIdentifiers = [];
    _topLevelList.forEach((element) {
      if (element.isCollection) {
        collectionIdentifiers.add(
          CollectionIdentifier(id: element.id, name: element.name),
        );
      }
    });
    return collectionIdentifiers;
  }

  TallyItem getParentItemByIndex(int itemIndex) {
    return _parentItemList[itemIndex];
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
      // I think that I may be already performing this check in the selection of
      // the collection in the new task creation
      CollectionIdentifier? newCollectionIdentifier;
      for (var i = 0; i < task.collectionMemberships.length; i++) {
        if (!collectionNames.contains(task.collectionMemberships[i].name)) {
          newCollectionIdentifier = CollectionIdentifier(
            id: task.collectionMemberships[i].id,
            name: task.collectionMemberships[i].name,
          );
          // There will only be one new collection per task creation by design.
          break;
        }
      }

      if (newCollectionIdentifier != null) {
        addCollection(
          TallyCollection(
            id: newCollectionIdentifier.id,
            name: newCollectionIdentifier.name,
          ),
        );
      }

      // add as child to all collection memberships
      task.collectionMemberships.forEach((collectionMember) {
        updateColletionTaskMembers(task.name, collectionMember);
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

  void updateColletionTaskMembers(
      String taskName, CollectionIdentifier parentCollection) {
    var collectionToUpdate = fetchItemToUpdate(parentCollection.id, true);
    // var collectionToUpdate = _topLevelList
    //     .firstWhere((item) => item.name == collectionName && item.isCollection);
    (collectionToUpdate as TallyCollection).addTallyTaskName(taskName);
    notifyListeners();
  }

  void updateTaskCollectionMemberships(
    String taskName,
    CollectionIdentifier parentCollection,
  ) {
    var itemToUpdate = _topLevelList
        .firstWhere((item) => item.name == taskName && !item.isCollection);
    (itemToUpdate as TallyTask).addToCollectionMemberships(parentCollection);
    notifyListeners();
  }
}
