import 'package:flutter/material.dart';

import '../models/quest_glyph.dart';

class GlyphIcon extends StatelessWidget {
  const GlyphIcon({
    super.key,
    required this.glyph,
    required this.color,
    required this.size,
  });

  final QuestGlyph glyph;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GlyphPainter(glyph: glyph, color: color),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  const _GlyphPainter({required this.glyph, required this.color});

  final QuestGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (glyph) {
      case QuestGlyph.clapperboard:
        _paintClapperboard(canvas, size, paint);
      case QuestGlyph.brain:
        _paintBrain(canvas, size, paint);
      case QuestGlyph.dumbbell:
        _paintDumbbell(canvas, size, paint);
      case QuestGlyph.swatches:
        _paintSwatches(canvas, size, paint);
      case QuestGlyph.mountain:
        _paintMountain(canvas, size, paint);
      case QuestGlyph.people:
        _paintPeople(canvas, size, paint);
      case QuestGlyph.dining:
        _paintDining(canvas, size, paint);
      case QuestGlyph.camera:
        _paintCamera(canvas, size, paint);
      case QuestGlyph.book:
        _paintBook(canvas, size, paint);
      case QuestGlyph.ticket:
        _paintTicket(canvas, size, paint);
      case QuestGlyph.music:
        _paintMusic(canvas, size, paint);
    }
  }

  void _paintClapperboard(Canvas canvas, Size size, Paint paint) {
    final stroke = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeJoin = StrokeJoin.round;

    final body = RRect.fromLTRBR(
      size.width * 0.14,
      size.height * 0.34,
      size.width * 0.86,
      size.height * 0.84,
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(body, stroke);

    final top = Path()
      ..moveTo(size.width * 0.16, size.height * 0.36)
      ..lineTo(size.width * 0.28, size.height * 0.14)
      ..lineTo(size.width * 0.86, size.height * 0.14)
      ..lineTo(size.width * 0.74, size.height * 0.36)
      ..close();
    canvas.drawPath(top, paint);
  }

  void _paintBrain(Canvas canvas, Size size, Paint paint) {
    final stroke = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final left = Rect.fromLTRB(
      size.width * 0.16,
      size.height * 0.18,
      size.width * 0.52,
      size.height * 0.82,
    );
    final right = Rect.fromLTRB(
      size.width * 0.48,
      size.height * 0.18,
      size.width * 0.84,
      size.height * 0.82,
    );
    canvas.drawArc(left, 0.4, 5.5, false, stroke);
    canvas.drawArc(right, 3.5, 5.5, false, stroke);
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.28),
      Offset(size.width * 0.5, size.height * 0.74),
      stroke,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.34, size.height * 0.46),
        width: size.width * 0.22,
        height: size.height * 0.2,
      ),
      3.4,
      2.4,
      false,
      stroke,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.66, size.height * 0.46),
        width: size.width * 0.22,
        height: size.height * 0.2,
      ),
      6.0,
      2.4,
      false,
      stroke,
    );
  }

  void _paintDumbbell(Canvas canvas, Size size, Paint paint) {
    final bar = RRect.fromLTRBR(
      size.width * 0.22,
      size.height * 0.44,
      size.width * 0.78,
      size.height * 0.56,
      Radius.circular(size.height * 0.06),
    );
    canvas.drawRRect(bar, paint);
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.10,
        size.height * 0.30,
        size.width * 0.28,
        size.height * 0.70,
        Radius.circular(size.width * 0.06),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.72,
        size.height * 0.30,
        size.width * 0.90,
        size.height * 0.70,
        Radius.circular(size.width * 0.06),
      ),
      paint,
    );
  }

  void _paintSwatches(Canvas canvas, Size size, Paint paint) {
    void card(double dx, double dy, double angle) {
      canvas.save();
      canvas.translate(size.width * dx, size.height * dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromLTRBR(
          -size.width * 0.16,
          -size.height * 0.22,
          size.width * 0.16,
          size.height * 0.22,
          Radius.circular(size.width * 0.04),
        ),
        paint,
      );
      canvas.restore();
    }

    card(0.38, 0.58, -0.55);
    card(0.50, 0.50, -0.15);
    card(0.64, 0.46, 0.35);
  }

  void _paintMountain(Canvas canvas, Size size, Paint paint) {
    final back = Path()
      ..moveTo(size.width * 0.42, size.height * 0.78)
      ..lineTo(size.width * 0.68, size.height * 0.30)
      ..lineTo(size.width * 0.92, size.height * 0.78)
      ..close();
    canvas.drawPath(back, paint..color = color.withValues(alpha: 0.7));
    paint.color = color;
    final front = Path()
      ..moveTo(size.width * 0.08, size.height * 0.78)
      ..lineTo(size.width * 0.38, size.height * 0.22)
      ..lineTo(size.width * 0.70, size.height * 0.78)
      ..close();
    canvas.drawPath(front, paint);
  }

  void _paintPeople(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.32), size.width * 0.13, paint);
    canvas.drawCircle(Offset(size.width * 0.64, size.height * 0.30), size.width * 0.11, paint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.38, size.height * 0.68),
        width: size.width * 0.42,
        height: size.height * 0.38,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.66, size.height * 0.66),
        width: size.width * 0.34,
        height: size.height * 0.32,
      ),
      paint,
    );
  }

  void _paintDining(Canvas canvas, Size size, Paint paint) {
    final stroke = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.18),
      Offset(size.width * 0.28, size.height * 0.82),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.22),
      Offset(size.width * 0.18, size.height * 0.48),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.38, size.height * 0.22),
      Offset(size.width * 0.38, size.height * 0.48),
      stroke,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.68, size.height * 0.38),
        width: size.width * 0.28,
        height: size.height * 0.42,
      ),
      3.3,
      2.8,
      false,
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.58),
      Offset(size.width * 0.68, size.height * 0.82),
      stroke,
    );
  }

  void _paintCamera(Canvas canvas, Size size, Paint paint) {
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.12,
        size.height * 0.32,
        size.width * 0.88,
        size.height * 0.82,
        Radius.circular(size.width * 0.1),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.30,
        size.height * 0.20,
        size.width * 0.52,
        size.height * 0.36,
        Radius.circular(size.width * 0.04),
      ),
      paint,
    );
    final lens = Paint()..color = const Color(0xFF192330);
    canvas.drawCircle(Offset(size.width * 0.52, size.height * 0.56), size.width * 0.14, lens);
  }

  void _paintBook(Canvas canvas, Size size, Paint paint) {
    final stroke = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeJoin = StrokeJoin.round;
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.18,
        size.height * 0.16,
        size.width * 0.82,
        size.height * 0.84,
        Radius.circular(size.width * 0.08),
      ),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.16),
      Offset(size.width * 0.50, size.height * 0.84),
      stroke,
    );
  }

  void _paintTicket(Canvas canvas, Size size, Paint paint) {
    final path = Path()
      ..addRRect(
        RRect.fromLTRBR(
          size.width * 0.14,
          size.height * 0.28,
          size.width * 0.86,
          size.height * 0.72,
          Radius.circular(size.width * 0.08),
        ),
      );
    canvas.drawPath(path, paint);
    final hole = Paint()..color = const Color(0xFF304961);
    canvas.drawCircle(Offset(size.width * 0.14, size.height * 0.5), size.width * 0.08, hole);
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.5), size.width * 0.08, hole);
  }

  void _paintMusic(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(Offset(size.width * 0.32, size.height * 0.72), size.width * 0.14, paint);
    canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.62), size.width * 0.14, paint);
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.40,
        size.height * 0.22,
        size.width * 0.50,
        size.height * 0.72,
        Radius.circular(4),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.76,
        size.height * 0.14,
        size.width * 0.86,
        size.height * 0.62,
        Radius.circular(4),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        size.width * 0.40,
        size.height * 0.14,
        size.width * 0.86,
        size.height * 0.28,
        Radius.circular(4),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) {
    return oldDelegate.glyph != glyph || oldDelegate.color != color;
  }
}
