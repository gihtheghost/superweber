import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';

class _WeberHopTransform {
  final double dy;
  final double scaleX;
  final double scaleY;

  const _WeberHopTransform({
    required this.dy,
    required this.scaleX,
    required this.scaleY,
  });
}

class StreetView extends ConsumerStatefulWidget {
  const StreetView({super.key});

  @override
  ConsumerState<StreetView> createState() => _StreetViewState();
}

class _StreetViewState extends ConsumerState<StreetView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  // Placeholder URLs as requested; user will host custom images later.
  static const String weberCatUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/weber_idle.png';
  static const String carSpriteUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/car_red.png';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  _WeberHopTransform _calculateWeberHop(double t, double maxJump) {
    // 1. dy (vertical jump arc up and down)
    double dy;
    if (t >= 0.15 && t < 0.75) {
      final u = (t - 0.15) / 0.60;
      dy = -maxJump * 4.0 * u * (1.0 - u);
    } else {
      dy = 0.0;
    }

    // 2. Squish squash & stretch: s < 0 = squash (crouch/impact), s > 0 = stretch
    double s;
    if (t < 0.15) {
      // Anticipation squash before leaping
      final u = t / 0.15;
      s = -0.18 * math.sin(u * math.pi);
    } else if (t < 0.35) {
      // Takeoff stretch upwards
      final u = (t - 0.15) / 0.20;
      s = 0.20 * math.sin(u * math.pi);
    } else if (t < 0.75) {
      // Air flight to descent
      final u = (t - 0.35) / 0.40;
      s = 0.06 * math.sin(u * math.pi);
    } else {
      // Landing impact squash
      final u = (t - 0.75) / 0.25;
      s = -0.16 * math.sin(u * math.pi);
    }

    final scaleY = 1.0 + s;
    final scaleX = 1.0 - (s * 0.80);

    return _WeberHopTransform(
      dy: dy,
      scaleX: scaleX,
      scaleY: scaleY,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final streetWidth = constraints.maxWidth;
          final streetHeight = constraints.maxHeight;
          final carStartX = (streetWidth - 90.0).clamp(100.0, 2000.0);

          // Car position: travels from streetWidth - 90 down to Weber at ~60
          final progress = gameState.carProgress;
          final weberMargin = 6;
          final weberSize = (streetHeight - (weberMargin * 2)).clamp(40.0, 160.0);
          final weberTop = (streetHeight - weberSize) / 0.5;
          final carMargin = 0.0;
          final carEndX = 14.0 + weberSize + 8.0;
          final carCurrentX = carStartX - (progress * (carStartX - carEndX));

          return ClipRect(
            child: Stack(
              children: [
                // 1. Parallax Street Background
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final offset = _animController.value;
                      return CustomPaint(
                        painter: _StreetParallaxPainter(
                          offset: offset,
                          roadColor: theme.brightness == Brightness.dark
                              ? const Color(0xFF212121)
                              : const Color(0xFF37474F),
                          lineColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                // 2. Weber Cat Sprite
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final t = _animController.value;
                    final maxJump = (weberSize * 0.18).clamp(8.0, 24.0);
                    final hop = _calculateWeberHop(t, maxJump);

                    return Positioned(
                      left: 14,
                      top: weberTop,
                      width: weberSize,
                      height: weberSize,
                      child: Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()
                          ..translateByDouble(0.0, hop.dy, 0.0, 1.0)
                          ..scaleByDouble(hop.scaleX, hop.scaleY, 1.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Image.network(
                    weberCatUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),

                // 3. Incoming Car or Explosion Effect
                if (gameState.isExploding)
                  Positioned(
                    left: carCurrentX - 20,
                    bottom: 0,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 700),
                      tween: Tween(begin: 0.6, end: 1.4),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrange,
                                  blurRadius: 25,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Positioned(
                    left: carCurrentX.clamp(carEndX, carStartX),
                    bottom: carMargin,
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        final t = _animController.value;
                        final slant = 0.1 * math.sin(t * 2 * math.pi);
                        final squish = 0.2 * math.sin(t * 4 * math.pi);

                        final transform = Matrix4.identity()
                          ..multiply(Matrix4.skewX(slant))
                          ..multiply(Matrix4.diagonal3Values(1.0 + squish, 1.0 - squish, 1.0));

                        return Transform(
                          alignment: Alignment.bottomCenter,
                          transform: transform,
                          child: child,
                        );
                      },
                      child: Image.network(
                        carSpriteUrl,
                        fit: BoxFit.contain,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                // 4. Top Overlay HUD (Score badge on top-right)
                Positioned(
                  top: 8,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amberAccent, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on, color: Colors.amberAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}

class _StreetParallaxPainter extends CustomPainter {
  final double offset;
  final Color roadColor;
  final Color lineColor;

  // Crie as tintas uma única vez:
  static final Paint _roadPaint = Paint();
  static final Paint _curbPaint = Paint()
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;
  static final Paint _dashPaint = Paint()..strokeWidth = 3.0;

  _StreetParallaxPainter({
    required this.offset,
    required this.roadColor,
    required this.lineColor,
  }) {
    _roadPaint.color = roadColor;
    _curbPaint.color = Colors.grey.shade600;
    _dashPaint.color = lineColor.withValues(alpha: 0.85);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Road surface
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _roadPaint);

    // Curb borders
    canvas.drawLine(const Offset(0, 2), Offset(size.width, 2), _curbPaint);
    canvas.drawLine(Offset(0, size.height - 2), Offset(size.width, size.height - 2), _curbPaint);

    // Dashed center markings
    const dashWidth = 24.0;
    const dashSpace = 20.0;
    const totalCycle = dashWidth + dashSpace;
    final startShift = -(offset * totalCycle);

    final midY = size.height * 0.55;
    double currentX = startShift;
    while (currentX < size.width) {
      if (currentX + dashWidth > 0) {
        canvas.drawLine(
          Offset(currentX, midY),
          Offset(currentX + dashWidth, midY),
          _dashPaint,
        );
      }
      currentX += totalCycle;
    }
  }

  @override
  bool shouldRepaint(_StreetParallaxPainter oldDelegate) =>
      oldDelegate.offset != offset ||
      oldDelegate.roadColor != roadColor ||
      oldDelegate.lineColor != lineColor;
}
