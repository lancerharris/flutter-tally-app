import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class SelectCollection extends StatefulWidget {
  const SelectCollection({Key? key, this.collectionNames}) : super(key: key);
  final List<String>? collectionNames;

  @override
  _SelectCollectionState createState() => _SelectCollectionState();
}

class _SelectCollectionState extends State<SelectCollection> {
  Map<String, bool> collectionMap = {};

  late FocusNode _focusNode2;

  @override
  void initState() {
    super.initState();
    _focusNode2 = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    if (collectionMap.isEmpty && widget.collectionNames != null) {
      widget.collectionNames!.forEach((name) {
        collectionMap[name] = false;
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Want this in a Collection?',
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 10),
        if (widget.collectionNames != null)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Add to existing:',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        if (widget.collectionNames != null)
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: widget.collectionNames!
                    .map((name) {
                      return GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, right: 10, bottom: 5, left: 10),
                            color: collectionMap[name] == true
                                ? Color.lerp(AppTheme.mainColor,
                                    AppTheme.secondaryColor, 0.05)
                                : AppTheme.disabledColor,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '$name',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                SizedBox(width: 10),
                                if (collectionMap[name] == true)
                                  Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                  )
                                else
                                  Icon(
                                    Icons.add,
                                    size: 16,
                                  )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (collectionMap[name] != null) {
                              collectionMap[name] = !collectionMap[name]!;
                            }
                          });
                        },
                      );
                    })
                    .toList()
                    .cast<Widget>(),
              )),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            widget.collectionNames != null
                ? 'Or create something new:'
                : 'Create something new:',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          // TODO (LH): handle the keyboard, it covers the text field
          // i also want tapping out of text field to close keyboard
          child: TextField(
            focusNode: _focusNode2,
            cursorColor:
                Color.lerp(AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05)!),
              ),
              labelText: 'i.e. Workouts',
              labelStyle: TextStyle(
                color: _focusNode2.hasFocus
                    ? Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05)
                    : null,
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_focusNode2);
              });
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode2.dispose();
    super.dispose();
  }
}
