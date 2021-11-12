import 'package:flutter/material.dart';
import 'package:tally_app/theme/app_theme.dart';

class SelectCollection extends StatefulWidget {
  const SelectCollection({
    Key? key,
    this.collectionNames,
    required this.addToCollectionMemberships,
    required this.setInputError,
    required this.removeFromCollectionMemberships,
    required this.collectionMemberships,
  }) : super(key: key);
  final List<String>? collectionNames;
  final List<String> collectionMemberships;
  final Function(String) addToCollectionMemberships;
  final Function(String, String) setInputError;
  final Function(String) removeFromCollectionMemberships;

  @override
  _SelectCollectionState createState() => _SelectCollectionState();
}

class _SelectCollectionState extends State<SelectCollection> {
  Map<String, bool> collectionMap = {};
  String newCollectionError = '';
  String? _newCollectionName;

  final _focusNode2 = FocusNode();
  final _collectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collectionController.addListener(() {
      if (widget.collectionNames != null) {
        // check if the error is already there and if it needs to be there
        var collectionAlreadyExists =
            widget.collectionNames!.contains(_collectionController.text);
        if (newCollectionError != '' || collectionAlreadyExists) {
          setState(() {
            newCollectionError = collectionAlreadyExists
                ? 'Can\'t have two collections with the same name'
                : '';

            widget.setInputError(
                'collectionSelectionError', newCollectionError);
          });
        }
      }
    });
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
        SizedBox(height: 15),
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
              padding: const EdgeInsets.only(left: 30, top: 15),
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
                          if (collectionMap[name] != null) {
                            if (!collectionMap[name]! == true) {
                              widget.addToCollectionMemberships(name);
                            } else {
                              widget.removeFromCollectionMemberships(name);
                            }
                            setState(() {
                              collectionMap[name] = !collectionMap[name]!;
                            });
                          }
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
          // TODO (LH): Add validation to not add a collection that already exists
          child: TextField(
            controller: _collectionController,
            focusNode: _focusNode2,
            maxLength: 40,
            cursorColor:
                Color.lerp(AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
            decoration: InputDecoration(
              errorText: newCollectionError != '' ? newCollectionError : null,
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
            onSubmitted: (inputString) {
              // remove the previous value sent to collectionMemberships
              if (_newCollectionName != null &&
                  _newCollectionName != inputString) {
                widget.collectionMemberships.remove(_newCollectionName);
              }
              if (!widget.collectionMemberships.contains(inputString)) {
                if (widget.collectionNames == null ||
                    !widget.collectionNames!.contains(inputString)) {
                  widget.addToCollectionMemberships(inputString);
                  _newCollectionName = inputString;
                }
              }
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
    _collectionController.dispose();

    super.dispose();
  }
}
