import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tally_app/Home/widgets/add_goal.dart';
import 'package:tally_app/Home/widgets/name_task.dart';
import 'package:tally_app/Home/widgets/select_collection.dart';
import 'package:tally_app/Home/widgets/title_bar.dart';

import 'package:tally_app/theme/app_theme.dart';

class NewTaskModal extends StatefulWidget {
  NewTaskModal(this.collectionNames);
  final List<String> collectionNames;

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(right: 15, left: 15),
              children: [
                NameTask(),
                Divider(),
                AddGoal(),
                Divider(),
                SelectCollection(collectionNames: widget.collectionNames),
                Divider(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cancel button'),
                    SizedBox(width: 10),
                    Text('Submit button')
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
