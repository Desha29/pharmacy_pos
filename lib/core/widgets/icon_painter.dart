import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class IconPainter extends CustomPainter {
  final String pathData;
  final Color color;

  IconPainter(this.pathData, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Simplified icon drawing - in a real app you'd parse SVG path data
    if (pathData.contains(
      'M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z',
    )) {
      // Dashboard grid icon
      _drawDashboardGrid(canvas, size, paint);
    } else if (pathData.contains('M7 4V2C7 1.45')) {
      // Sales POS icon
      _drawShoppingBag(canvas, size, paint);
    } else if (pathData.contains(
      'M19 3H5C3.9 3 3 3.9 3 5V19C3 20.1 3.9 21 5 21H19C20.1 21 21 20.1 21 19V5C21 3.9 20.1 3 19 3ZM19 19H5V5H19V19ZM17 8.5L13.5 12L17 15.5L15.5 17L12 13.5L8.5 17L7 15.5L10.5 12L7 8.5L8.5 7L12 10.5L15.5 7L17 8.5Z',
    )) {
      // Inventory icon
      _drawInventory(canvas, size, paint);
    } else if (pathData.contains(
      'M14 2H6C4.9 2 4 2.9 4 4V20C4 21.1 4.89 22 5.99 22H18C19.1 22 20 21.1 20 20V8L14 2ZM18 20H6V4H13V9H18V20Z',
    )) {
      // Invoice document icon
      _drawDocument(canvas, size, paint);
    } else if (pathData.contains(
      'M19.35 10.04C18.67 6.59 15.64 4 12 4C9.11 4 6.6 5.64 5.35 8.04C2.34 8.36 0 10.91 0 14C0 17.31 2.69 20 6 20H19C21.76 20 24 17.76 24 15C24 12.36 21.95 10.22 19.35 10.04ZM17 13L12 18L7 13H10V9H14V13H17Z',
    )) {
      // Cloud sync icon
      _drawCloud(canvas, size, paint);
    } else if (pathData.contains(
      'M19.14 12.94C19.18 12.64 19.2 12.33 19.2 12S19.18 11.36 19.14 11.06L21.16 9.48C21.34 9.34 21.39 9.07 21.28 8.87L19.36 5.55C19.24 5.33 18.99 5.26 18.77 5.33L16.38 6.29C15.88 5.91 15.35 5.59 14.76 5.35L14.4 2.81C14.36 2.57 14.16 2.4 13.92 2.4H10.08C9.84 2.4 9.64 2.57 9.6 2.81L9.24 5.35C8.65 5.59 8.12 5.92 7.62 6.29L5.23 5.33C5.01 5.26 4.76 5.33 4.64 5.55L2.72 8.87C2.61 9.07 2.66 9.34 2.84 9.48L4.86 11.06C4.82 11.36 4.8 11.67 4.8 12S4.82 12.64 4.86 12.94L2.84 14.52C2.66 14.66 2.61 14.93 2.72 15.13L4.64 18.45C4.76 18.67 5.01 18.74 5.23 18.67L7.62 17.71C8.12 18.08 8.65 18.41 9.24 18.65L9.6 21.19C9.64 21.43 9.84 21.6 10.08 21.6H13.92C14.16 21.6 14.36 21.43 14.4 21.19L14.76 18.65C15.35 18.41 15.88 18.08 16.38 17.71L18.77 18.67C18.99 18.74 19.24 18.67 19.36 18.45L21.28 15.13C21.39 14.93 21.34 14.66 21.16 14.52L19.14 12.94ZM12 15.6C10.02 15.6 8.4 13.98 8.4 12S10.02 8.4 12 8.4S15.6 10.02 15.6 12S13.98 15.6 12 15.6Z',
    )) {
      // Settings gear icon
      _drawGear(canvas, size, paint);
    } else {
      // Default rectangle
      _drawRectangle(canvas, size, paint);
    }
  }

  void _drawDashboardGrid(Canvas canvas, Size size, Paint paint) {
    final cellSize = size.width * 0.35;
    final gap = size.width * 0.1;

    // Top left
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, cellSize, cellSize),
        const Radius.circular(2),
      ),
      paint,
    );

    // Top right
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cellSize + gap, 0, cellSize, cellSize),
        const Radius.circular(2),
      ),
      paint,
    );

    // Bottom left
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, cellSize + gap, cellSize, cellSize),
        const Radius.circular(2),
      ),
      paint,
    );

    // Bottom right
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cellSize + gap, cellSize + gap, cellSize, cellSize),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  void _drawShoppingBag(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );

    // Handle
    final handlePath = Path();
    handlePath.moveTo(size.width * 0.35, size.height * 0.3);
    handlePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width * 0.65,
      size.height * 0.3,
    );

    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(handlePath, handlePaint);
  }

  void _drawInventory(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );

    // X mark
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.35),
      Offset(size.width * 0.65, size.height * 0.65),
      strokePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.35, size.height * 0.65),
      strokePaint,
    );
  }

  void _drawDocument(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );

    // Corner fold
    final foldPath = Path();
    foldPath.moveTo(size.width * 0.6, size.height * 0.1);
    foldPath.lineTo(size.width * 0.75, size.height * 0.25);
    foldPath.lineTo(size.width * 0.6, size.height * 0.25);
    foldPath.close();
    canvas.drawPath(foldPath, paint);
  }

  void _drawCloud(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);

    // Main cloud body
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.1, center.dy),
      size.width * 0.25,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx + size.width * 0.1, center.dy),
      size.width * 0.2,
      paint,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy - size.width * 0.1),
      size.width * 0.15,
      paint,
    );
  }

  void _drawGear(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.4;
    final innerRadius = size.width * 0.25;

    // Outer gear teeth
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      final x = center.dx + outerRadius * math.cos(angle);
      final y = center.dy + outerRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Inner circle
    canvas.drawCircle(center, innerRadius, paint);
  }

  void _drawRectangle(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
