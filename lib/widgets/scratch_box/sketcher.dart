import 'package:flutter/material.dart';

import './drawn_line.dart';

class Sketcher extends CustomPainter {
  Sketcher({required this.line, required this.animationsComplete});
  final DrawnLine? line;
  final bool animationsComplete;
  final int lineMaxLength = 75;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = line != null ? line!.width : 5.0
      ..strokeJoin = StrokeJoin.bevel;

    if (line != null) {
      // paint.color = line!.color;
      // paint.strokeWidth = line!.width;

      // add a lineMaxLength to save some computation
      if (line!.path.length <= lineMaxLength) {
        for (int i = 0; i < line!.path.length - 1; i++) {
          // print(i);
          canvas.drawLine(line!.path[i], line!.path[i + 1], paint);
        }
      } else {
        for (int i = line!.path.length - lineMaxLength - 1;
            i < line!.path.length - 1;
            i++) {
          // print(i);
          canvas.drawLine(line!.path[i], line!.path[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return animationsComplete;
  }
}
