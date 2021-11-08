import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class NameTask extends StatefulWidget {
  const NameTask({Key? key}) : super(key: key);

  @override
  State<NameTask> createState() => _NameTaskState();
}

class _NameTaskState extends State<NameTask> {
  late FocusNode _focusNode1;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
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
              focusNode: _focusNode1,
              cursorColor:
                  Color.lerp(AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.lerp(
                          AppTheme.mainColor, AppTheme.secondaryColor, 0.05)!),
                ),
                labelText: 'i.e. Do something exciting',
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
            )),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    super.dispose();
  }
}
