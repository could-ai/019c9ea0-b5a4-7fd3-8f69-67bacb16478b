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
    // Use a gradient to simulate subtle lighting/texture
    final Paint floorPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFFFFFFF),
          const Color(0xFFF0F0F0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    
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

    // SHADOWS (Draw these first so they are under objects)
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Shadow for Back Wall
    canvas.drawRect(Rect.fromLTWH(0.2 * m, 0.2 * m, w, 0.5 * m), shadowPaint);
    // Shadow for Side Wall
    canvas.drawRect(Rect.fromLTWH(0.2 * m, 0.2 * m, 0.5 * m, 5 * m), shadowPaint);
    // Shadow for Center Plinth
    canvas.drawRect(Rect.fromCenter(center: Offset(w/2 + 0.2*m, h/2 + 0.2*m), width: 3 * m, height: 3 * m), shadowPaint);
    // Shadow for Counter
    // (Simplified shadow rect for complex shape)
    canvas.drawRect(Rect.fromLTWH(10.2 * m, 11.2 * m, 4 * m, 3 * m), shadowPaint);


    // 2. Matte Black Branding Walls (Back and Partial Side)
    // Back Wall: 15m wide, 0.5m thick
    final Paint wallPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF2A2A2A), // Lighter top (lighting)
          const Color(0xFF000000), // Darker bottom
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, 5 * m)); // Approximate rect for shader
    
    // Back Wall
    canvas.drawRect(Rect.fromLTWH(0, 0, w, 0.5 * m), wallPaint);
    
    // Side Wall Segment (Left, 5m long)
    canvas.drawRect(Rect.fromLTWH(0, 0, 0.5 * m, 5 * m), wallPaint);

    // LED Screen on Back Wall (Centered, 6m wide)
    final Paint ledScreenPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF333333), Color(0xFF111111)],
      ).createShader(Rect.fromLTWH(4.5 * m, 0.1 * m, 6 * m, 0.3 * m));
    canvas.drawRect(Rect.fromLTWH(4.5 * m, 0.1 * m, 6 * m, 0.3 * m), ledScreenPaint);
    
    // Illuminated Logo Glow (Behind/On wall)
    if (showLighting) {
      final Paint logoGlow = Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withOpacity(0.8), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(w/2, 0.25 * m), radius: 2 * m));
      canvas.drawCircle(Offset(w/2, 0.25 * m), 2 * m, logoGlow);
    }

    // 3. Central Travertine Plinths (3 plinths)
    final Paint travertinePaint = Paint()
      ..color = const Color(0xFFE3DCCB);
      // Note: Real texture would require an image shader, using solid color for now
    
    // Center Plinth (Large)
    canvas.drawRect(Rect.fromCenter(center: Offset(w/2, h/2), width: 3 * m, height: 3 * m), travertinePaint);
    // Inner detail to simulate top surface vs edge
    canvas.drawRect(Rect.fromCenter(center: Offset(w/2, h/2), width: 2.8 * m, height: 2.8 * m), Paint()..color = const Color(0xFFEBE5D5));
    
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

    // Counter Top Highlight
    final Paint oakTopPaint = Paint()..color = const Color(0xFF5D4633);
    Path counterTopPath = Path();
    counterTopPath.moveTo(10.1 * m, 11.1 * m);
    counterTopPath.lineTo(13.9 * m, 11.1 * m);
    counterTopPath.lineTo(13.9 * m, 13.9 * m);
    counterTopPath.lineTo(13.1 * m, 13.9 * m);
    counterTopPath.lineTo(13.1 * m, 12.1 * m);
    counterTopPath.lineTo(10.1 * m, 12.1 * m);
    counterTopPath.close();
    canvas.drawPath(counterTopPath, oakTopPaint);


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
    // Shadow
    canvas.drawRect(sofa1.shift(Offset(0.1*m, 0.1*m)), shadowPaint);
    canvas.drawRect(sofa1, loungePaint);
    canvas.drawRect(sofa1, framePaint);
    // Cushions
    canvas.drawRect(Rect.fromLTWH(1.2*m, 11.1*m, 0.8*m, 0.8*m), Paint()..color = Colors.grey.shade100);
    canvas.drawRect(Rect.fromLTWH(2.1*m, 11.1*m, 0.8*m, 0.8*m), Paint()..color = Colors.grey.shade100);
    canvas.drawRect(Rect.fromLTWH(3.0*m, 11.1*m, 0.8*m, 0.8*m), Paint()..color = Colors.grey.shade100);


    // Sofa 2
    Rect sofa2 = Rect.fromLTWH(1 * m, 13 * m, 3 * m, 1 * m);
    // Shadow
    canvas.drawRect(sofa2.shift(Offset(0.1*m, 0.1*m)), shadowPaint);
    canvas.drawRect(sofa2, loungePaint);
    canvas.drawRect(sofa2, framePaint);
    // Cushions
    canvas.drawRect(Rect.fromLTWH(1.2*m, 13.1*m, 0.8*m, 0.8*m), Paint()..color = Colors.grey.shade100);
    canvas.drawRect(Rect.fromLTWH(2.1*m, 13.1*m, 0.8*m, 0.8*m), Paint()..color = Colors.grey.shade100);
    canvas.drawRect(Rect.fromLTWH(3.0*m, 13.1*m, 0.8*m, 0.8*m), Paint()..color = Colors.grey.shade100);

    
    // Coffee Table
    canvas.drawCircle(Offset(2.5 * m, 12.5 * m), 0.5 * m, oakPaint);

    // 6. Lighting (Soft Warm 3000K)
    if (showLighting) {
      final Paint warmLight = Paint()
        ..color = const Color(0xFFFFE0B2).withOpacity(0.2) // Warm yellow tint
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

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
