import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tally_app/widgets/scratch_box/custom_pan_gesture.dart';

import './drawn_line.dart';
import './sketcher.dart';

class ScratchBox extends StatefulWidget {
  const ScratchBox(
      {Key? key,
      this.backdropHeight = 100,
      this.backdropWidth = double.infinity})
      : super(key: key);
  final double backdropHeight;
  final double backdropWidth;
  @override
  _ScratchBoxState createState() => _ScratchBoxState();
}

class _ScratchBoxState extends State<ScratchBox> with TickerProviderStateMixin {
  List<DrawnLine> lines = <DrawnLine>[];
  late DrawnLine? line;
  var selectedColor = Colors.black;
  var selectedWidth = 5.0;

  final backdropColor = Colors.blue;

  var scratchCount = 0;

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

    scratchCount++;
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

    return Center(
      child: Container(
        height: widget.backdropHeight,
        width: widget.backdropWidth,
        margin: EdgeInsets.all(opaqueContainerMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: backdropColor,
        ),
        child: Stack(
          alignment: Alignment.center,
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
                                  for (line in lines) buildPath(context, line),
                                buildCurrentPath(
                                  context,
                                  // math to keep drawn lines in parent container
                                ),
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
              left: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Scratch Box',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
          ],
        ),
      ),
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
