import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/new_task/new_task_modal.dart';
import 'package:tally_app/providers/task_manager.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
        iconSize: 30,
        onPressed: () async {
          var collectionNames =
              Provider.of<TaskManager>(context, listen: false).collectionNames;
          var taskNames =
              Provider.of<TaskManager>(context, listen: false).taskNames;
          var newTask = await showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              context: context,
              constraints: BoxConstraints(
                maxHeight: 500,
                maxWidth: 750,
              ),
              builder: (context) => NewTaskModal(
                  collections: collectionNames, taskNames: taskNames));

          if (newTask != null) {
            Provider.of<TaskManager>(context, listen: false)
                .createTask(newTask);
          }
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}
