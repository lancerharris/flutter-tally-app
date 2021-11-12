import 'package:flutter/material.dart';

import 'package:tally_app/theme/app_theme.dart';

class CompleteTaskCreation extends StatelessWidget {
  const CompleteTaskCreation({
    Key? key,
    required this.completeTaskCreation,
    required this.errorExists,
    required this.taskName,
  }) : super(key: key);
  final Function(bool) completeTaskCreation;
  final String? taskName;
  final bool errorExists;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.only(
              top: 5,
              right: 10,
              bottom: 5,
              left: 10,
            ),
            color: !errorExists && taskName != null
                ? AppTheme.secondaryColor
                : AppTheme.disabledColor,
            child: GestureDetector(
              child: Text(
                'Add Task',
                style: !errorExists && taskName != null
                    ? Theme.of(context).textTheme.button
                    : AppTheme.disabledThemes.button,
              ),
              onTap: () {
                completeTaskCreation(true);
              },
            ),
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }
}
