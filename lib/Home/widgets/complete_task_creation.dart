import 'package:flutter/material.dart';

import 'package:tally_app/theme/app_theme.dart';

class CompleteTaskCreation extends StatelessWidget {
  const CompleteTaskCreation({
    Key? key,
    required this.completeTaskCreation,
    required this.inputError,
    required this.taskName,
  }) : super(key: key);
  final Function(bool) completeTaskCreation;
  final String? taskName;
  final String inputError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.only(
                  top: 5,
                  right: 10,
                  bottom: 5,
                  left: 10,
                ),
                color: AppTheme.errorColor,
                child: GestureDetector(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onTap: () {
                    completeTaskCreation(false);
                  },
                ),
              ),
            ),
            SizedBox(width: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.only(
                  top: 5,
                  right: 10,
                  bottom: 5,
                  left: 10,
                ),
                color: inputError == '' && taskName != null
                    ? AppTheme.secondaryColor
                    : AppTheme.disabledColor,
                child: GestureDetector(
                  child: Text(
                    'Add Task',
                    style: inputError == '' && taskName != null
                        ? Theme.of(context).textTheme.button
                        : AppTheme.disabledThemes.button,
                  ),
                  onTap: () {
                    completeTaskCreation(true);
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20)
      ],
    );
  }
}
