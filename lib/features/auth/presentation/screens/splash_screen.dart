import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3B5C),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom Logo
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CustomPaint(
                    painter: _FintechLogoPainter(),
                  ),
                ),

                const SizedBox(height: 24),

                // App Name
                const Text(
                  'FinTech App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                const Text(
                  'Smart Gaming. Real Money.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 60),

                // Loading indicator
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: const Color(0xFFD4AF37).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FintechLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // ── Outer glow ring ──────────────────────────────────────────
    final glowPaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r, glowPaint);

    // ── Gold circle border ────────────────────────────────────────
    final ringPaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(cx, cy), r - 2, ringPaint);

    // ── Rising bar chart (3 bars) ─────────────────────────────────
    final barPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final barRadius = const Radius.circular(3);
    final barWidth = size.width * 0.11;
    final baseY = cy + r * 0.28;
    final heights = [r * 0.30, r * 0.50, r * 0.72];
    final startX = cx - barWidth * 3.2;
    final gap = barWidth * 1.6;

    for (int i = 0; i < 3; i++) {
      final left = startX + i * gap;
      final top = baseY - heights[i];
      canvas.drawRRect(
        RRect.fromLTRBR(left, top, left + barWidth, baseY, barRadius),
        barPaint,
      );
    }

    // ── Upward trend arrow line over bars ────────────────────────
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(startX + barWidth / 2, baseY - heights[0]);
    path.lineTo(startX + gap + barWidth / 2, baseY - heights[1]);
    path.lineTo(startX + 2 * gap + barWidth / 2, baseY - heights[2]);
    canvas.drawPath(path, linePaint);

    // Arrowhead at the tip
    final tipX = startX + 2 * gap + barWidth / 2;
    final tipY = baseY - heights[2];
    final arrowPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    final arrow = Path();
    arrow.moveTo(tipX + 7, tipY - 7);
    arrow.lineTo(tipX - 1, tipY - 1);
    arrow.lineTo(tipX + 1, tipY + 7);
    arrow.close();
    canvas.drawPath(arrow, arrowPaint);

    // ── Small gold coin circle (bottom-right accent) ──────────────
    final coinPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + r * 0.42, cy + r * 0.42), r * 0.16, coinPaint);

    final coinRingPaint = Paint()
      ..color = const Color(0xFF1A3B5C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(Offset(cx + r * 0.42, cy + r * 0.42), r * 0.09, coinRingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}