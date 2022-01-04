import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/tally_item.dart';
import '../models/tally_collection.dart';
import '../models/tally_task.dart';
import './hive_manager.dart';

enum CollectionStatus { isNotCollection, isCollection }
enum NotifyFlag { doNotNotify, doNotify }
enum ParentStatus { inChildList, inParentList }

class TaskManager with ChangeNotifier {
  List<TallyItem> _topLevelList = [];
  List<TallyItem> _parentItemList = [];
  List<TallyTask> _childItemList = [];
  HiveManager hiveManager = HiveManager();

  Future<void> readTallyTasks() async {
    List<TallyTask> tallyTasks = await hiveManager.readTallyTasks();
    _topLevelList.addAll(tallyTasks);
  }

  Future<void> readTallyCollections() async {
    List<TallyCollection> tallyCollections =
        await hiveManager.readTallyCollections();
    _topLevelList.addAll(tallyCollections);
  }

  Future<void> readHiveData() async {
    readTallyTasks();
    readTallyCollections();
  }

  Future<void> getInitialData() async {
    await readHiveData();
    createParentItemList();
    createChildItemList();
  }

  TallyItem getItemToUpdate(String name, CollectionStatus collectionStatus) {
    return _topLevelList.firstWhere(
        (item) => item.name == name && item.isCollection == collectionStatus);
  }

  void updateExpansion(String name, CollectionStatus collectionStatus) {
    var tallyItem = getItemToUpdate(name, collectionStatus);

    tallyItem.isExpanded = !tallyItem.isExpanded;

    notifyListeners();
  }

  void updateCount(
      String name, int intToAdd, CollectionStatus collectionStatus) {
    var tallyItem = getItemToUpdate(name, collectionStatus) as TallyTask;
    tallyItem.count += intToAdd;

    if (collectionStatus == CollectionStatus.isCollection) {
      var collections = tallyItem.collectionMemberships;
      collections.forEach((collection) {
        var collectionToUpdate =
            getItemToUpdate(name, CollectionStatus.isCollection);
        collectionToUpdate.count += intToAdd;
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

  void createParentItemList([NotifyFlag shouldNotify = NotifyFlag.doNotify]) {
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
    if (shouldNotify == NotifyFlag.doNotify) {
      notifyListeners();
    }
  }

  // ? maybe this would get expensive with many collections or tasks
  // ? instead of updating many collections maybe I could update a single map
  // ? that holds info with task names as keys and positions as values.
  // ? that way there may be less writes to db or whatever
  void updateItemPositions(
      int oldPositionInList, int newPositionInList, ParentStatus parentStatus) {
    final operableList = parentStatus == ParentStatus.inParentList
        ? _parentItemList
        : _childItemList;
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

  void createChildItemList([NotifyFlag shouldNotify = NotifyFlag.doNotify]) {
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

    if (shouldNotify == NotifyFlag.doNotify) {
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

  List<String> get CollectionNames {
    List<String> collectionNames = [];
    _topLevelList.forEach((element) {
      if (element.isCollection) {
        collectionNames.add(
          element.name,
        );
      }
    });
    return collectionNames;
  }

  TallyItem getParentItemByIndex(int itemIndex) {
    return _parentItemList[itemIndex];
  }

  void updateTopLevelList(
      String name, CollectionStatus collectionStatus, TallyItem item,
      [NotifyFlag shouldNotify = NotifyFlag.doNotNotify]) {
    var replacementIndex = _topLevelList.indexWhere(
        (item) => item.name == name && item.isCollection == collectionStatus);

    _topLevelList.replaceRange(replacementIndex, replacementIndex + 1, [item]);
    if (shouldNotify == NotifyFlag.doNotify) {
      notifyListeners();
    }
  }

  void addTask(TallyTask task) {
    Hive.box('tally_tasks').add(task);
    _topLevelList.add(task);
    if (task.inCollection) {
      _childItemList.add(task);

      // add the new collection
      // I think that I may be already performing this check in the selection of
      // the collection in the new task creation
      String? newCollectionName;
      for (var i = 0; i < task.collectionMemberships.length; i++) {
        if (!collectionNames.contains(task.collectionMemberships[i])) {
          newCollectionName = task.collectionMemberships[i];
          // There will only be one new collection per task creation by design.
          break;
        }
      }

      // add as child to all collection memberships
      final olderCollections = task.collectionMemberships.where((collection) {
        if (newCollectionName == null)
          return true;
        else
          return collection != newCollectionName;
      });

      olderCollections.toList().forEach((collection) {
        updateColletionMembers(task.name, collection);
      });

      if (newCollectionName != null) {
        final newTallyCollection = TallyCollection(
          name: newCollectionName,
          dateCreated: task.dateCreated,
        );

        newTallyCollection.addTallyTaskName(task.name);
        addCollection(newTallyCollection);
      }
    } else {
      _parentItemList.add(task);
      // only notify if not in collection. otherwise wait for collection add.
      notifyListeners();
    }
  }

  void addCollection(TallyCollection collection) {
    Hive.box('tally_collections').add(collection);
    _topLevelList.add(collection);
    // add to parent since can't be child by design.
    _parentItemList.add(collection);
    notifyListeners();
  }

  void updateColletionMembers(String taskName, String parentCollection) {
    var collectionToUpdate =
        getItemToUpdate(parentCollection, CollectionStatus.isCollection);
    // var collectionToUpdate = _topLevelList
    //     .firstWhere((item) => item.name == collectionName && item.isCollection);
    (collectionToUpdate as TallyCollection).addTallyTaskName(taskName);
    notifyListeners();
  }

  void updateTaskCollectionMemberships(
    String taskName,
    String parentCollection,
  ) {
    var itemToUpdate = _topLevelList
        .firstWhere((item) => item.name == taskName && !item.isCollection);
    (itemToUpdate as TallyTask).addToCollectionMemberships(parentCollection);
    notifyListeners();
  }
}
