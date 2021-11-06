import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class NewTaskModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              color: AppTheme.secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New Tally Task',
                      style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
