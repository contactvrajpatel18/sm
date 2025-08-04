import 'dart:math';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const Loader({
    Key? key,
    this.size = 40.0,
    this.color = Colors.blue,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _ArcPainter(
              rotation: _controller.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double rotation;
  final Color color;
  final double strokeWidth;

  _ArcPainter({
    required this.rotation,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Rect rect = Offset.zero & size;
    const double startAngle = -pi / 2;
    const double sweepAngle = pi * 1.5;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(2 * pi * rotation);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => true;
}
