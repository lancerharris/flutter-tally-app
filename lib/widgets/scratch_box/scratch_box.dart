import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tally_app/providers/task_manager.dart';
import 'package:tally_app/theme/app_theme.dart';
import 'package:tally_app/widgets/scratch_box/custom_pan_gesture.dart';

import './drawn_line.dart';
import './sketcher.dart';

class ScratchBox extends StatefulWidget {
  const ScratchBox({
    Key? key,
    required this.itemName,
    this.backdropHeight = 100,
    this.backdropWidth = double.infinity,
  }) : super(key: key);
  final String itemName;
  final double backdropHeight;
  final double backdropWidth;
  @override
  _ScratchBoxState createState() => _ScratchBoxState();
}

class _ScratchBoxState extends State<ScratchBox> with TickerProviderStateMixin {
  List<DrawnLine> lines = <DrawnLine>[];
  late DrawnLine? line;
  var selectedColor = Colors.black;
  var selectedWidth = 3.0;

  final backdropColor = AppTheme.disabledColor;

  // var scratchCount = 0;

  final opaqueContainerMargin = 10.0;

  final scaleAnimBegin = 1.0;
  final scaleAnimEnd = 1.05;
  final opacityAnimBegin = 1.0;
  final opacityAnimEnd = 0.0;
  final scaleAnimDuration = const Duration(milliseconds: 250);
  final fadeOutDuration = const Duration(milliseconds: 250);
  final fadeInDuration = Duration.zero;
  late AnimationController scaleAnimController;
  late AnimationController opacityAnimController;
  late Animation scaleAnimation;
  late Animation opacityAnimation;
  bool animationsComplete = true;
  final maxScratchMarks = 5;

  PointerDeviceKind kind = PointerDeviceKind.unknown;

  // two streams for the lines so that olderlines don't get continually repainted
  final currentLineStreamController = StreamController<DrawnLine?>.broadcast();
  final lineStreamController = StreamController<DrawnLine?>.broadcast();

  final animationCompleteController = StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    scaleAnimController =
        AnimationController(vsync: this, duration: scaleAnimDuration);

    scaleAnimation = Tween(begin: scaleAnimBegin, end: scaleAnimEnd)
        .animate(scaleAnimController);

    opacityAnimController =
        AnimationController(vsync: this, duration: fadeOutDuration);

    opacityAnimation = Tween(begin: opacityAnimBegin, end: opacityAnimEnd)
        .animate(opacityAnimController);
  }

  Future<void> animateScale() async {
    await scaleAnimController.animateTo(scaleAnimEnd,
        curve: Curves.easeInCubic);
    await scaleAnimController.reverse();
  }

  Future<void> animateOpacity() async {
    if (opacityAnimation.value == 1) {
      await opacityAnimController.animateBack(opacityAnimBegin);
      await opacityAnimController.animateTo(opacityAnimEnd,
          duration: fadeInDuration);
    }
  }

  void onPanStart(PointerDownEvent details, [bool addToLines = false]) {
    if (!animationsComplete) {
      return;
    }
    RenderBox scratchBox = context.findRenderObject() as RenderBox;
    var localPosition = scratchBox.globalToLocal(details.position);
    line = DrawnLine([localPosition], selectedColor, selectedWidth);
    if (line == null) {
      throw Exception(['Line failed to create']);
    }
    lines.add(line!);
    // this line is to draw a point from itself to itself so that you start with
    // a dot without having to drag your finger
    lines[lines.length - 1].path.add(localPosition);

    if (addToLines) {
      lineStreamController.add(lines[lines.length - 1]);
    } else {
      currentLineStreamController.add(lines[lines.length - 1]);
    }

    // scratchCount++;
    Provider.of<TaskManager>(context, listen: false)
        .updateCount(widget.itemName, 1, false);
  }

  void onPanUpdate(PointerMoveEvent details) {
    // handle the case where a pan was started during an animation, where lines
    // list is empty
    if (!animationsComplete || lines.isEmpty) {
      return;
    }
    RenderBox scratchBox = context.findRenderObject() as RenderBox;
    var localPosition = scratchBox.globalToLocal(details.position);
    lines[lines.length - 1].path.add(localPosition);
    currentLineStreamController.add(lines[lines.length - 1]);
  }

  Future<void> onPanEnd(PointerUpEvent details) async {
    // handle the case where a pan was started during an animation, when the
    // list is empty, then onPanEnd gets called after the animation is done;
    if (!animationsComplete || lines.isEmpty) {
      return;
    }
    if (lines.length == maxScratchMarks) {
      await clearScratchBox();
    } else {
      lineStreamController.add(lines[lines.length - 1]);
    }
  }

  void onPlusPress() async {
    // if not currently animating, add lines. o/w just add to count
    if (animationsComplete) {
      RenderBox scratchBox = context.findRenderObject() as RenderBox;
      var lineIncrements = 15;
      var yOffset1 = 12;
      var yOffset2 = -33;
      int xOffset1;
      int xOffset2;

      if (lines.length == 4) {
        xOffset1 = -lineIncrements * 2 - 10;
        xOffset2 = lineIncrements * 2 + 10;
        yOffset1 = yOffset1 - 10;
        yOffset2 = yOffset2 + 10;
      } else {
        xOffset1 = -lineIncrements * 2 + lines.length * lineIncrements;
        xOffset2 = xOffset1 + lineIncrements;
      }
      line = DrawnLine([
        Offset(scratchBox.size.width / 2 + xOffset1,
            scratchBox.size.height / 2 + yOffset1),
        Offset(scratchBox.size.width / 2 + xOffset2,
            scratchBox.size.height / 2 + yOffset2),
      ], selectedColor, selectedWidth);
      if (line == null) {
        throw Exception(['Line failed to create']);
      } else {
        lines.add(line!);
      }

      lineStreamController.add(lines[lines.length - 1]);
      if (lines.length == maxScratchMarks) {
        await clearScratchBox();
      }
    }
    // scratchCount++;
    Provider.of<TaskManager>(context, listen: false)
        .updateCount(widget.itemName, 1, false);
  }

  void onMinusPress() async {
    // only add or remove line if not animating, o/w just decrement count
    if (animationsComplete && lines.length > 0) {
      if (lines.length > 1) {
        lines.removeLast();
        // nothing is really being added, just notifying to redraw lines.
        lineStreamController.add(lines[lines.length - 1]);
      } else {
        lines = <DrawnLine>[];

        line = null;
        lineStreamController.add(line);
      }
    }

    Provider.of<TaskManager>(context, listen: false)
        .updateCount(widget.itemName, -1, false);
  }

  Future<void> clearScratchBox() async {
    // once five tallies have been made erase so there is room for the next
    // five.
    // set state is called twice so you cant make marks in the gesture detector
    // while animating

    // stop gesture detector from detecting
    animationsComplete = false;
    animationCompleteController.add(null);

    await animateScale();
    await animateOpacity();

    lines = <DrawnLine>[];
    // provide the empty list so that the older lines are erased
    lineStreamController.add(line);

    line = null;
    currentLineStreamController.add(line);

    // let the gesture detector detect
    animationsComplete = true;
    animationCompleteController.add(null);
  }

  Widget buildCurrentPath(BuildContext context) {
    // I think repaint boundary is good when we need to tell flutter
    // "hey this is going to repaint a lot. but not everything around it"
    // from should repaint doc of custom painter class
    // If a custom delegate has a particularly expensive paint function
    // such that repaints should be avoided as much as possible, a
    // [RepaintBoundary] or [RenderRepaintBoundary] (or other render
    // object with [RenderObject.isRepaintBoundary] set to true) might
    //be helpful.
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        CustomPanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<CustomPanGestureRecognizer>(
          () => CustomPanGestureRecognizer(
            onStart: onPanStart,
            onUpdate: onPanUpdate,
            onEnd: onPanEnd,
          ),
          (CustomPanGestureRecognizer instance) {},
        ),
      },
      child: RepaintBoundary(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.transparent,
          ),
          child: StreamBuilder<DrawnLine?>(
            stream: currentLineStreamController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                // complex enough i think since it redraws the whole line with
                // each movement
                isComplex: true,
                painter: Sketcher(
                    line: snapshot.data,
                    animationsComplete: animationsComplete),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildPath(BuildContext context, DrawnLine? line) {
    return RepaintBoundary(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        child: CustomPaint(
          painter: Sketcher(
            line: line,
            animationsComplete: animationsComplete,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final computedBackdropWidth = MediaQuery.of(context).size.width;

    return Container(
      height: widget.backdropHeight,
      width: widget.backdropWidth,
      decoration: BoxDecoration(
        color: AppTheme.secondaryCardColor,
        // don't do top to make it appear to be part of parent card
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Stack(alignment: Alignment.center, children: [
        Neumorphic(
          margin: EdgeInsets.all(opaqueContainerMargin),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
            depth: -2,
            color: AppTheme.scratchBoxColor,
            intensity: 0.6,
            shadowDarkColor: Colors.red,
            shadowDarkColorEmboss: Colors.black,
            border: NeumorphicBorder(
              color: AppTheme.secondaryCardColor,
              width: 5,
            ),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // ClipRect ensures that the size doesn't exceed the parent constraints
              ClipRect(
                child: AnimatedBuilder(
                  animation: opacityAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: opacityAnimation.value,
                      child: child,
                    );
                  },
                  child: AnimatedBuilder(
                    animation: scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: scaleAnimation.value,
                        child: child,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        StreamBuilder<DrawnLine?>(
                            stream: lineStreamController.stream,
                            builder: (context, snapshot) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (lines.isNotEmpty)
                                    for (line in lines)
                                      buildPath(context, line),
                                  buildCurrentPath(context),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              //backdrop

              Positioned(
                top: 8,
                left: 8,
                child: IgnorePointer(
                  child: NeumorphicText(
                    'ScratchBox',
                    style: NeumorphicStyle(
                        lightSource: LightSource.topLeft,
                        depth: 0.5,
                        shadowDarkColor: Colors.black),
                    // using ! to make this textStyle work for now
                    textStyle: NeumorphicTextStyle(
                        fontFamilyFallback: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .fontFamilyFallback,
                        fontWeight: FontWeight.w900,
                        decoration:
                            Theme.of(context).textTheme.bodyText1!.decoration,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1!.fontSize,
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1!.fontFamily,
                        debugLabel:
                            Theme.of(context).textTheme.bodyText1!.debugLabel,
                        fontFeatures:
                            Theme.of(context).textTheme.bodyText1!.fontFeatures,
                        fontStyle:
                            Theme.of(context).textTheme.bodyText1!.fontStyle,
                        letterSpacing: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .letterSpacing,
                        height: Theme.of(context).textTheme.bodyText1!.height,
                        locale: Theme.of(context).textTheme.bodyText1!.locale,
                        textBaseline:
                            Theme.of(context).textTheme.bodyText1!.textBaseline,
                        wordSpacing:
                            Theme.of(context).textTheme.bodyText1!.wordSpacing),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.remove),
                  ),
                  onTap: onMinusPress,
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.add),
                  ),
                  onTap: onPlusPress,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    currentLineStreamController.close();
    animationCompleteController.close();
    lineStreamController.close();
    scaleAnimController.dispose();
    opacityAnimController.dispose();
    super.dispose();
  }
}
