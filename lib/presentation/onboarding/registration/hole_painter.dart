import 'package:flutter/material.dart';

class HolePainter extends CustomPainter {
  final double bottomPadding;
  final double cornerWidth;
  final double borderRadius;

  HolePainter({this.bottomPadding = 0, this.cornerWidth = 20, this.borderRadius = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final paintLines = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    paint.color = Colors.black.withOpacity(0.3);

    final width = size.width * 0.7;
    final left = (size.width - width) / 2;
    final top = (size.height - width) / 2 - bottomPadding;
    // Lines Start
    final p1 = Offset(left, top);
    final p2 = Offset(left, top + 30);
    canvas.drawLine(p1, p2, paintLines);
    final p3 = Offset(left, top);
    final p4 = Offset(left + 30, top);
    canvas.drawLine(p3, p4, paintLines);
    final p5 = Offset(left + width, top);
    final p6 = Offset(left + width - 30, top);
    canvas.drawLine(p5, p6, paintLines);
    final p7 = Offset(left + width, top);
    final p8 = Offset(left + width, top + 30);
    canvas.drawLine(p7, p8, paintLines);
    final p9 = Offset(left + width, top + width);
    final p10 = Offset(left + width, top + width - 30);
    canvas.drawLine(p9, p10, paintLines);
    final p11 = Offset(left + width, top + width);
    final p12 = Offset(left + width - 30, top + width);
    canvas.drawLine(p11, p12, paintLines);
    final p13 = Offset(left, top + width);
    final p14 = Offset(left, top + width - 30);
    canvas.drawLine(p13, p14, paintLines);
    final p15 = Offset(left, top + width);
    final p16 = Offset(left + 30, top + width);
    canvas.drawLine(p15, p16, paintLines);

    //Lines end
    var rRect = Rect.fromLTRB(
      left,
      top,
      left + width,
      top + width,
    );
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRect(rRect)
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
