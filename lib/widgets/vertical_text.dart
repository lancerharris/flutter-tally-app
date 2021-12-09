import 'package:flutter/material.dart';

class VerticalizeLetters extends StatelessWidget {
  const VerticalizeLetters(
      {Key? key,
      required this.verticalLetters,
      required this.verticalLetterSpacing,
      this.extraSpace,
      this.style})
      : super(key: key);
  final List<String> verticalLetters;
  // using List since different letters look different w/ different spacings
  final List<double> verticalLetterSpacing;
  // if the sized box isn't big enough add some extraSpace
  final num? extraSpace;
  final TextStyle? style;

  Widget stringPlusPosition(
      BuildContext context, String verticalString, double topOffset) {
    return Positioned(
      top: topOffset,
      child: Text(
        verticalString,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // add largest spacing to make room for the first letter
    var maxLetterSpace = verticalLetterSpacing.reduce(
        (currentValue, nextValue) =>
            currentValue > nextValue ? currentValue : nextValue);
    var totalSize = verticalLetterSpacing
            .reduce((currentValue, nextValue) => currentValue + nextValue) +
        maxLetterSpace +
        (extraSpace ?? 0.0);

    return SizedBox(
      height: totalSize,
      child: Stack(
        children: [
          // firts letter. won't work in loop for some reason
          Text(
            verticalLetters[0],
            style: Theme.of(context).textTheme.headline3,
          ),
          for (var i = 1; i < verticalLetters.length; i++)
            stringPlusPosition(
                context, verticalLetters[i], i * verticalLetterSpacing[i - 1]),
        ],
      ),
    );
  }
}
