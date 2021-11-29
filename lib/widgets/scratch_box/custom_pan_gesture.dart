// thanks to help from
// https://medium.com/koahealth/combining-multiple-gesturedetectors-in-flutter-26d899d008b2
// https://github.com/davidanaya/flutter-circular-slider/blob/c8517fd193aa971037590ce52db02a5475db53bb/lib/src/circular_slider_paint.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class CustomPanGestureRecognizer extends OneSequenceGestureRecognizer {
  CustomPanGestureRecognizer({
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
  });

  final Function onStart;
  final Function onUpdate;
  final Function onEnd;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
    // declare as victor in the gesture arena
    resolve(GestureDisposition.accepted);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      onStart(event);
    } else if (event is PointerMoveEvent) {
      onUpdate(event);
    } else if (event is PointerUpEvent) {
      onEnd(event);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
