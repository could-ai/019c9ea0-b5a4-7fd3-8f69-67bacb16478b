import 'package:flutter/material.dart';
import 'dart:math' as math;

class StandLayoutPainter extends CustomPainter {
  final bool showLighting;
  final bool showDimensions;

  StandLayoutPainter({required this.showLighting, required this.showDimensions});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    // Scale: 15m = w (width of canvas)
    // 1m = w / 15
    final double m = w / 15.0;

    // 1. Floor Base (15x15m)
    final Paint floorPaint = Paint()..color = const Color(0xFFFDFDFD); // Very light grey/white
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), floorPaint);

    // Grid lines (1m grid) - Subtle
    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 15; i++) {
      double pos = i * m;
      canvas.drawLine(Offset(pos, 0), Offset(pos, h), gridPaint);
      canvas.drawLine(Offset(0, pos), Offset(w, pos), gridPaint);
    }

    // 2. Matte Black Branding Walls (Back and Partial Side)
    // Back Wall: 15m wide, 0.5m thick
    final Paint wallPaint = Paint()
      ..color = const Color(0xFF1A1A1A) // Matte Black
      ..style = PaintingStyle.fill;
    
    // Back Wall
    canvas.drawRect(Rect.fromLTWH(0, 0, w, 0.5 * m), wallPaint);
    
    // Side Wall Segment (Left, 5m long)
    canvas.drawRect(Rect.fromLTWH(0, 0, 0.5 * m, 5 * m), wallPaint);

    // LED Screen on Back Wall (Centered, 6m wide)
    final Paint ledScreenPaint = Paint()..color = const Color(0xFF222222);
    canvas.drawRect(Rect.fromLTWH(4.5 * m, 0.1 * m, 6 * m, 0.3 * m), ledScreenPaint);
    
    // Illuminated Logo Glow (Behind/On wall)
    if (showLighting) {
      final Paint logoGlow = Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withOpacity(0.6), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(w/2, 0.25 * m), radius: 2 * m));
      canvas.drawCircle(Offset(w/2, 0.25 * m), 2 * m, logoGlow);
    }

    // 3. Central Travertine Plinths (3 plinths)
    final Paint travertinePaint = Paint()..color = const Color(0xFFE3DCCB); // Beige/Travertine
    
    // Center Plinth (Large)
    canvas.drawRect(Rect.fromCenter(center: Offset(w/2, h/2), width: 3 * m, height: 3 * m), travertinePaint);
    
    // Side Plinths (Smaller)
    canvas.drawRect(Rect.fromCenter(center: Offset(w/2 - 4 * m, h/2), width: 1.5 * m, height: 1.5 * m), travertinePaint);
    canvas.drawRect(Rect.fromCenter(center: Offset(w/2 + 4 * m, h/2), width: 1.5 * m, height: 1.5 * m), travertinePaint);

    // 4. Hospitality Counter (Dark Oak) - Bottom Right
    final Paint oakPaint = Paint()..color = const Color(0xFF4A3728); // Dark Oak
    // L-Shape Counter
    Path counterPath = Path();
    counterPath.moveTo(10 * m, 11 * m);
    counterPath.lineTo(14 * m, 11 * m);
    counterPath.lineTo(14 * m, 14 * m);
    counterPath.lineTo(13 * m, 14 * m);
    counterPath.lineTo(13 * m, 12 * m);
    counterPath.lineTo(10 * m, 12 * m);
    counterPath.close();
    canvas.drawPath(counterPath, oakPaint);

    // Hidden Storage (Behind Counter)
    final Paint storagePaint = Paint()..color = Colors.grey.shade400;
    canvas.drawRect(Rect.fromLTWH(14 * m, 10 * m, 1 * m, 5 * m), storagePaint);

    // 5. Lounge Seating (White Upholstery, Black Frames) - Bottom Left
    final Paint loungePaint = Paint()..color = Colors.white;
    final Paint framePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Sofa 1
    Rect sofa1 = Rect.fromLTWH(1 * m, 11 * m, 3 * m, 1 * m);
    canvas.drawRect(sofa1, loungePaint);
    canvas.drawRect(sofa1, framePaint);

    // Sofa 2
    Rect sofa2 = Rect.fromLTWH(1 * m, 13 * m, 3 * m, 1 * m);
    canvas.drawRect(sofa2, loungePaint);
    canvas.drawRect(sofa2, framePaint);
    
    // Coffee Table
    canvas.drawCircle(Offset(2.5 * m, 12.5 * m), 0.5 * m, oakPaint);

    // 6. Lighting (Soft Warm 3000K)
    if (showLighting) {
      final Paint warmLight = Paint()
        ..color = const Color(0xFFFFE0B2).withOpacity(0.15) // Warm yellow tint
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      // Ambient wash over center
      canvas.drawCircle(Offset(w/2, h/2), 6 * m, warmLight);
      
      // Highlight over lounge
      canvas.drawCircle(Offset(2.5 * m, 12.5 * m), 3 * m, warmLight);
      
      // Highlight over counter
      canvas.drawCircle(Offset(12 * m, 12.5 * m), 3 * m, warmLight);
    }

    // 7. Text Labels & Dimensions
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    void drawLabel(String text, Offset position, {Color color = Colors.black}) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    drawLabel("BRANDING WALL", Offset(w/2, 0.25 * m), color: Colors.white);
    drawLabel("TRAVERTINE PLINTHS", Offset(w/2, h/2));
    drawLabel("LOUNGE", Offset(2.5 * m, 12.5 * m));
    drawLabel("HOSPITALITY", Offset(12 * m, 12.5 * m));

    if (showDimensions) {
      // Draw dimension lines
      final Paint dimPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 1;
      
      // Width 15m
      canvas.drawLine(Offset(0, h - 10), Offset(w, h - 10), dimPaint);
      drawLabel("15m", Offset(w/2, h - 25), color: Colors.red);
      
      // Height 15m
      canvas.drawLine(Offset(w - 10, 0), Offset(w - 10, h), dimPaint);
      // Rotate text for vertical dimension would require canvas rotation, keeping simple for now
    }
  }

  @override
  bool shouldRepaint(covariant StandLayoutPainter oldDelegate) {
    return oldDelegate.showLighting != showLighting || oldDelegate.showDimensions != showDimensions;
  }
}
