import 'package:flutter/material.dart';
import 'package:tally_app/data/motivations.dart';

import 'package:tally_app/theme/app_theme.dart';

class SelectCollection extends StatefulWidget {
  const SelectCollection({
    Key? key,
    required this.collections,
    required this.addToCollectionMemberships,
    required this.setInputError,
    required this.removeFromCollectionMemberships,
    required this.collectionMemberships,
  }) : super(key: key);
  final List<String> collections;
  final List<String> collectionMemberships;
  final Function(String) addToCollectionMemberships;
  final Function(String, String) setInputError;
  final Function(String) removeFromCollectionMemberships;

  @override
  _SelectCollectionState createState() => _SelectCollectionState();
}

class _SelectCollectionState extends State<SelectCollection> {
  String newCollectionError = '';
  String? _newCollectionName;
  String? _selectedCollectionName;
  String? _collectionOption;
  final _collectionOption1 = 'Add to existing';
  final _collectionOption2 = 'Create new';
  bool _addCollection = true;
  final _focusNode2 = FocusNode();
  final _collectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collectionController.addListener(
      () {
        // check if the error is already there and if it needs to be there
        var collectionAlreadyExists =
            checkCollectionExistence(_collectionController.text);

        if (newCollectionError != '' || collectionAlreadyExists) {
          setState(() {
            newCollectionError = collectionAlreadyExists
                ? 'Can\'t have two collections with the same name'
                : '';

            widget.setInputError(
                'collectionSelectionError', newCollectionError);
          });
        }
      },
    );
  }

  bool checkCollectionExistence(String possibleName) {
    for (var i = 0; i < widget.collections.length; i++) {
      if (widget.collections[i] == possibleName) {
        return true;
      }
    }

    return false;
  }

  bool checkCollectionMembershipExistence(String possibleName) {
    for (var i = 0; i < widget.collectionMemberships.length; i++) {
      if (widget.collectionMemberships[i] == possibleName) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Place in a Collection?',
              style: Theme.of(context).textTheme.headline2,
            ),
            Row(
              children: [
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, right: 15, bottom: 5, left: 15),
                      color: _addCollection
                          ? Color.lerp(AppTheme.mainColor,
                              AppTheme.secondaryColor, 0.0750)
                          : AppTheme.disabledColor,
                      child: Text(
                        'Yes',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _addCollection = !_addCollection;
                    });
                  },
                ),
                SizedBox(width: 15),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, right: 15, bottom: 5, left: 15),
                      color: _addCollection
                          ? AppTheme.disabledColor
                          : Color.lerp(AppTheme.mainColor,
                              AppTheme.secondaryColor, 0.05),
                      child: Text('No',
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _addCollection = !_addCollection;
                    });
                  },
                ),
                SizedBox(width: 25)
              ],
            ),
          ],
        ),
        if (_addCollection)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              if (widget.collections.length > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // a bit hacky with the spacer in the list below
                  children: [_collectionOption1, 'spacer', _collectionOption2]
                      .map((collectionOption) {
                    if (_collectionOption == null) {
                      _collectionOption = collectionOption;
                    }
                    if (collectionOption == 'spacer') {
                      return Text(
                        'Or',
                        style: Theme.of(context).textTheme.headline3,
                      );
                    }
                    return GestureDetector(
                      child: collectionOptions(
                        optionName: collectionOption,
                        optionSelected: _collectionOption == collectionOption,
                        inputColor: _collectionOption == collectionOption
                            ? Color.lerp(AppTheme.mainColor,
                                AppTheme.secondaryColor, 0.0750)!
                            : AppTheme.disabledColor,
                      ),
                      onTap: () {
                        setState(() {
                          _collectionOption = collectionOption;
                          if (_selectedCollectionName != null &&
                              _collectionOption == _collectionOption2) {
                            widget.removeFromCollectionMemberships(
                                _selectedCollectionName!);
                            if (_newCollectionName != null) {
                              widget.addToCollectionMemberships(
                                  _newCollectionName!);
                            }
                          } else if (_selectedCollectionName != null &&
                              _collectionOption == _collectionOption1) {
                            if (_newCollectionName != null) {
                              widget.removeFromCollectionMemberships(
                                  _newCollectionName!);
                            }
                            widget.addToCollectionMemberships(
                                _selectedCollectionName!);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              if (_collectionOption == _collectionOption1)
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30),
                  child: Text('Add to Existing:',
                      style: Theme.of(context).textTheme.headline3),
                ),
              if (_collectionOption == _collectionOption1)
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 15),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: widget.collections
                        .map((collectionName) {
                          return GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 5, right: 10, bottom: 5, left: 10),
                                color: _selectedCollectionName == collectionName
                                    ? Color.lerp(AppTheme.mainColor,
                                        AppTheme.secondaryColor, 0.05)
                                    : AppTheme.disabledColor,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      '${collectionName}',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    SizedBox(width: 10),
                                    if (_selectedCollectionName ==
                                        collectionName)
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
                                if (_selectedCollectionName != collectionName) {
                                  // remove whatever was the selected collection
                                  // from the collection memeberships
                                  if (_selectedCollectionName != null) {
                                    widget.removeFromCollectionMemberships(
                                        _selectedCollectionName!);
                                  }
                                  _selectedCollectionName = collectionName;
                                  widget.addToCollectionMemberships(
                                      collectionName);
                                } else {
                                  _selectedCollectionName = null;
                                  widget.removeFromCollectionMemberships(
                                      collectionName);
                                }
                              });
                            },
                          );
                        })
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              if (_collectionOption == _collectionOption2 ||
                  widget.collections.length == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30),
                  child: Text('Create something new:',
                      style: Theme.of(context).textTheme.headline3),
                ),
              if (_collectionOption == _collectionOption2 ||
                  widget.collections.length == 0)
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: TextField(
                    controller: _collectionController,
                    focusNode: _focusNode2,
                    maxLength: 40,
                    cursorColor: Color.lerp(
                        AppTheme.mainColor, AppTheme.secondaryColor, 0.05),
                    decoration: InputDecoration(
                      errorText:
                          newCollectionError != '' ? newCollectionError : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.lerp(AppTheme.mainColor,
                                AppTheme.secondaryColor, 0.05)!),
                      ),
                      labelText: 'i.e. ${getRandomCollectionMotivation()}',
                      labelStyle: TextStyle(
                        color: _focusNode2.hasFocus
                            ? Color.lerp(AppTheme.mainColor,
                                AppTheme.secondaryColor, 0.05)
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
                        widget.removeFromCollectionMemberships(
                            _newCollectionName!);
                      }
                      var isAlreadyMember =
                          checkCollectionMembershipExistence(inputString);
                      var isAlreadyCollection =
                          checkCollectionExistence(inputString);
                      if (!isAlreadyMember && !isAlreadyCollection ||
                          widget.collections == null) {
                        _newCollectionName = inputString;
                        widget.addToCollectionMemberships(
                            _newCollectionName ?? '');
                      }
                    },
                  ),
                ),
            ],
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

// this could be made more dynamic and return all the options instead of one
// by stringing containers and conditioning on whether its the first or last
// container for rounding.
class collectionOptions extends StatelessWidget {
  const collectionOptions(
      {Key? key,
      required this.optionName,
      required this.optionSelected,
      required this.inputColor})
      : super(key: key);
  final String optionName;

  final bool optionSelected;
  final Color inputColor;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: inputColor,
          border: Border(
            left: BorderSide(
                color: optionSelected
                    ? Colors.transparent
                    : AppTheme.disabledColor,
                width: 1),
          ),
        ),
        padding: EdgeInsets.only(top: 8, right: 0, bottom: 8, left: 0),
        child: Text(
          optionName,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
