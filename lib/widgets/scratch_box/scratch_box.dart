import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './drawn_line.dart';
import './sketcher.dart';

class ScratchBox extends StatefulWidget {
  @override
  _ScratchBoxState createState() => _ScratchBoxState();
}

class _ScratchBoxState extends State<ScratchBox> with TickerProviderStateMixin {
  List<DrawnLine> lines = <DrawnLine>[];
  late DrawnLine? line;
  var selectedColor = Colors.black;
  var selectedWidth = 10.0;

  final backdropColor = Colors.blue;
  final backdropHeight = 300.0;

  var scratchCount = 0;

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

  // two streams for the lines so that olderlines don't get continually repainted
  final currentLineStreamController = StreamController<DrawnLine?>.broadcast();
  final lineStreamController = StreamController<DrawnLine?>.broadcast();

  final scratchCountController = StreamController<void>.broadcast();
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

  void onPanStart(DragStartDetails details) {
    line = DrawnLine([details.localPosition], selectedColor, selectedWidth);
    if (line == null) {
      throw Exception(['Line failed to create']);
    }
    lines.add(line!);
    // this line is to draw a point from itself to itself so that you start with
    // a dot without having to drag your finger
    lines[lines.length - 1].path.add(details.localPosition);
    currentLineStreamController.add(lines[lines.length - 1]);

    scratchCount++;
    scratchCountController.add(null);
  }

  void onPanUpdate(DragUpdateDetails details) {
    lines[lines.length - 1].path.add(details.localPosition);
    currentLineStreamController.add(lines[lines.length - 1]);
  }

  Future<void> onPanEnd(DragEndDetails details) async {
    // once five tallies have been made erase so there is room for the next
    // five.
    // set state is called twice so you cant make marks in the gesture detector
    // while animating
    if (lines.length == 5) {
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
    } else {
      lineStreamController.add(lines[lines.length - 1]);
    }
  }

  Widget buildCurrentPath(
      BuildContext context, double backdropHeight, double backdropWidth) {
    // I think repaint boundary is good when we need to tell flutter
    // "hey this is going to repaint a lot. but not everything around it"
    // from should repaint doc of custom painter class
    // If a custom delegate has a particularly expensive paint function
    // such that repaints should be avoided as much as possible, a
    // [RepaintBoundary] or [RenderRepaintBoundary] (or other render
    // object with [RenderObject.isRepaintBoundary] set to true) might
    //be helpful.
    return StreamBuilder<void>(
        stream: animationCompleteController.stream,
        builder: (context, snapshot) {
          return GestureDetector(
            onPanStart: animationsComplete ? onPanStart : null,
            onPanUpdate: animationsComplete ? onPanUpdate : null,
            onPanEnd: animationsComplete ? onPanEnd : null,
            child: RepaintBoundary(
              child: Container(
                color: Colors.transparent,
                width: backdropWidth,
                height: backdropHeight,
                child: StreamBuilder<DrawnLine?>(
                  stream: currentLineStreamController.stream,
                  builder: (context, snapshot) {
                    return CustomPaint(
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
        });
  }

  Widget buildPath(BuildContext context, double backdropHeight,
      double backdropWidth, DrawnLine? line) {
    return RepaintBoundary(
      child: Container(
        color: Colors.transparent,
        width: backdropWidth,
        height: backdropHeight,
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
    final backdropWidth = MediaQuery.of(context).size.width * 7 / 8;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: backdropColor,
            height: backdropHeight,
            width: backdropWidth,
          ),
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
                  children: [
                    StreamBuilder<DrawnLine?>(
                        stream: lineStreamController.stream,
                        builder: (context, snapshot) {
                          return Stack(
                            children: [
                              if (lines.isNotEmpty)
                                for (line in lines)
                                  buildPath(context, backdropHeight * 0.95,
                                      backdropWidth * 0.95, line),
                              buildCurrentPath(context, backdropHeight * 0.95,
                                  backdropWidth * 0.95),
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
              child: StreamBuilder<void>(
                  stream: scratchCountController.stream,
                  builder: (context, snapshot) {
                    return Text(
                      'Count: $scratchCount',
                      style: Theme.of(context).textTheme.headline6,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    currentLineStreamController.close();
    scratchCountController.close();
    animationCompleteController.close();
    lineStreamController.close();
    scaleAnimController.dispose();
    opacityAnimController.dispose();
    super.dispose();
  }
}
