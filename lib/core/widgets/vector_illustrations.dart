import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Custom automotive logo for ServisKu
class ServisKuLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;

  const ServisKuLogoWidget({super.key, this.size = 64, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(size: Size(size, size), painter: _LogoPainter()),
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ServisKu',
                style: TextStyle(
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Perawatan Motor Pribadi',
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background rounded squircle
    final bgPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.26),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Inner subtle stroke
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04;
    canvas.drawRRect(rrect.deflate(w * 0.04), borderPaint);

    // Speedometer / Gauge arc
    final arcPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;

    final center = Offset(w * 0.5, h * 0.55);
    final radius = w * 0.28;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      arcPaint,
    );

    // Gauge needle pointing up-right
    final needlePaint = Paint()
      ..color =
          const Color(0xFFFFD54F) // Gold/yellow needle
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + radius * 0.7 * math.cos(math.pi * 1.7),
      center.dy + radius * 0.7 * math.sin(math.pi * 1.7),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Center pin
    final pinPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, w * 0.07, pinPaint);

    // Wrench accent on top right
    final wrenchPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final wrenchPath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.75, h * 0.28), radius: w * 0.08),
      );
    canvas.drawPath(wrenchPath, wrenchPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hero Motorcycle Illustration widget
class MotorcycleHeroWidget extends StatelessWidget {
  final String motorcycleType; // matic, bebek, sport
  final double height;

  const MotorcycleHeroWidget({
    super.key,
    required this.motorcycleType,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _MotorcycleHeroPainter(motorcycleType: motorcycleType),
      ),
    );
  }
}

class _MotorcycleHeroPainter extends CustomPainter {
  final String motorcycleType;

  _MotorcycleHeroPainter({required this.motorcycleType});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5;

    // Soft ground shadow
    final shadowPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h * 0.88),
        width: w * 0.75,
        height: h * 0.12,
      ),
      shadowPaint,
    );

    // Wheels
    final wheelRadius = h * 0.22;
    final rearCenter = Offset(cx - w * 0.24, h * 0.72);
    final frontCenter = Offset(cx + w * 0.24, h * 0.72);

    final tirePaint = Paint()
      ..color = const Color(0xFF2B303A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = wheelRadius * 0.35;

    final rimPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = wheelRadius * 0.12;

    final hubPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Rear wheel
    canvas.drawCircle(rearCenter, wheelRadius, tirePaint);
    canvas.drawCircle(rearCenter, wheelRadius * 0.7, rimPaint);
    canvas.drawCircle(rearCenter, wheelRadius * 0.25, hubPaint);

    // Front wheel
    canvas.drawCircle(frontCenter, wheelRadius, tirePaint);
    canvas.drawCircle(frontCenter, wheelRadius * 0.7, rimPaint);
    canvas.drawCircle(frontCenter, wheelRadius * 0.25, hubPaint);

    // Motorcycle Body / Frame based on type
    final bodyPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final darkMetalPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.04
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final bodyPath = Path();

    if (motorcycleType.toLowerCase() == 'sport') {
      // Sport bike aggressive tank and fairing
      bodyPath.moveTo(
        rearCenter.dx - wheelRadius * 0.4,
        rearCenter.dy - wheelRadius * 0.7,
      );
      bodyPath.lineTo(cx - w * 0.08, h * 0.35); // seat
      bodyPath.lineTo(cx + w * 0.04, h * 0.25); // high tank
      bodyPath.lineTo(cx + w * 0.18, h * 0.30); // front cowl
      bodyPath.lineTo(
        frontCenter.dx - wheelRadius * 0.2,
        frontCenter.dy - wheelRadius * 0.8,
      );
      bodyPath.lineTo(cx, h * 0.65); // engine belly pan
      bodyPath.close();

      // Front fork
      canvas.drawLine(
        Offset(cx + w * 0.18, h * 0.32),
        frontCenter,
        darkMetalPaint,
      );
      // Swingarm
      canvas.drawLine(
        Offset(cx - w * 0.02, h * 0.62),
        rearCenter,
        darkMetalPaint,
      );
    } else if (motorcycleType.toLowerCase() == 'bebek') {
      // Underbone / Bebek frame
      bodyPath.moveTo(
        rearCenter.dx - wheelRadius * 0.3,
        rearCenter.dy - wheelRadius * 0.6,
      );
      bodyPath.lineTo(cx - w * 0.05, h * 0.42); // seat
      bodyPath.lineTo(cx + w * 0.05, h * 0.48); // step-through dip
      bodyPath.lineTo(cx + w * 0.15, h * 0.30); // handlebar head
      bodyPath.lineTo(cx + w * 0.12, h * 0.55); // leg shield
      bodyPath.lineTo(cx, h * 0.68); // engine
      bodyPath.close();

      // Front fork
      canvas.drawLine(
        Offset(cx + w * 0.15, h * 0.32),
        frontCenter,
        darkMetalPaint,
      );
      canvas.drawLine(
        Offset(cx - w * 0.02, h * 0.65),
        rearCenter,
        darkMetalPaint,
      );
    } else {
      // Matic / Scooter step-through with floorboard
      bodyPath.moveTo(
        rearCenter.dx - wheelRadius * 0.4,
        rearCenter.dy - wheelRadius * 0.6,
      );
      bodyPath.lineTo(cx - w * 0.06, h * 0.40); // seat
      bodyPath.lineTo(cx - w * 0.04, h * 0.58); // under-seat box
      bodyPath.lineTo(cx + w * 0.08, h * 0.58); // flat floorboard
      bodyPath.lineTo(cx + w * 0.15, h * 0.32); // front apron
      bodyPath.lineTo(cx + w * 0.10, h * 0.62); // front cowl bottom
      bodyPath.lineTo(cx - w * 0.12, h * 0.68); // cvt case
      bodyPath.close();

      // Front fork
      canvas.drawLine(
        Offset(cx + w * 0.14, h * 0.34),
        frontCenter,
        darkMetalPaint,
      );
    }

    canvas.drawPath(bodyPath, bodyPaint);

    // Handlebar & Mirror
    final handlePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.035
      ..strokeCap = StrokeCap.round;

    final barHead = Offset(cx + w * 0.14, h * 0.28);
    canvas.drawLine(
      barHead,
      Offset(barHead.dx - w * 0.03, barHead.dy - h * 0.08),
      handlePaint,
    );
    canvas.drawCircle(
      Offset(barHead.dx - w * 0.03, barHead.dy - h * 0.08),
      h * 0.025,
      bodyPaint,
    );

    // Seat cushion
    final seatPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    final seatRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - w * 0.16, h * 0.35, w * 0.18, h * 0.09),
      Radius.circular(h * 0.04),
    );
    canvas.drawRRect(seatRect, seatPaint);

    // Headlight glow
    final lightPaint = Paint()
      ..color = const Color(0xFFFDE047)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + w * 0.20, h * 0.35),
        width: w * 0.04,
        height: h * 0.08,
      ),
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MotorcycleHeroPainter oldDelegate) =>
      oldDelegate.motorcycleType != motorcycleType;
}

/// Generic vector empty state illustration
class EmptyIllustrationWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyIllustrationWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(icon, size: 48, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
