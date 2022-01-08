import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

import '../data/motivations.dart';

class NameTask extends StatefulWidget {
  const NameTask({
    Key? key,
    this.taskNames,
    required this.setTaskNameCallback,
    required this.setInputError,
  }) : super(key: key);
  final List<String>? taskNames;
  final Function(String) setTaskNameCallback;
  final Function(String, String) setInputError;

  @override
  State<NameTask> createState() => _NameTaskState();
}

class _NameTaskState extends State<NameTask> {
  String newTaskNameError = '';

  final _focusNode1 = FocusNode();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (widget.taskNames != null) {
        // check if the error is already there and if it needs to be there
        var taskAlreadyExists =
            widget.taskNames!.contains(_nameController.text);
        if (newTaskNameError != '' || taskAlreadyExists) {
          setState(() {
            newTaskNameError = taskAlreadyExists
                ? 'Can\'t have two tasks with the same name'
                : '';

            widget.setInputError('taskNameError', newTaskNameError);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Name your new Task',
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextField(
            controller: _nameController,
            focusNode: _focusNode1,
            maxLength: 40,
            cursorColor:
                Color.lerp(AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
            decoration: InputDecoration(
              errorText: newTaskNameError != '' ? newTaskNameError : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05)!),
              ),
              labelText: 'i.e. ${getRandomTaskMotivation()}',
              labelStyle: TextStyle(
                color: _focusNode1.hasFocus
                    ? Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05)
                    : null,
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_focusNode1);
              });
            },
            onSubmitted: (inputString) {
              if (widget.taskNames == null ||
                  !widget.taskNames!.contains(inputString)) {
                widget.setTaskNameCallback(inputString);
              }
            },
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
