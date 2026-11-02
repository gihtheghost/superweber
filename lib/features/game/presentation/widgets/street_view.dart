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
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final AnimationController _roadController;

  // Placeholder URLs as requested; user will host custom images later.
  static const String weberCatUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/weber_idle.png';
  static const String carSpriteUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/car_red.png';
  static const String explosionSpriteUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/explosion.gif';
  static const String roadTileUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/rua.png';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat();

    _roadController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _roadController.dispose();
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
          final weberMargin = streetHeight * 0.05;
          final weberSize = streetHeight * 0.75;
          final carMargin = streetHeight * 0.08;
          final carSize = streetHeight * 0.7;
          final carEndX = 14.0 + weberSize + 8.0;
          final carCurrentX = carStartX - (progress * (carStartX - carEndX));

          return ClipRect(
            child: Stack(
              children: [
                // 1. Parallax Street Background
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _roadController,
                    builder: (context, _) {
                      final offset = _roadController.value;

                      const double imgOriginalWidth = 1920;
                      const double imgOriginalHeight = 216;

                      final tileWidth = streetHeight * (imgOriginalWidth / imgOriginalHeight);
                      final shift = -(offset * tileWidth);

                      return ClipRect(
                        child: Stack(
                          children: [
                            for (double x = shift; x < streetWidth + tileWidth; x += tileWidth)
                              Positioned(
                                left: x,
                                top: 0,
                                bottom: 0,
                                width: tileWidth,
                                child: Image.network(
                                  roadTileUrl,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                          ],
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
                      bottom: weberMargin,
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
                    left: carCurrentX,
                    bottom: carMargin - (carSize * 0.8),
                    child: Image.network(
                      explosionSpriteUrl,
                      key: ValueKey(gameState.score),
                      height: carSize * 2.5,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_fire_department,
                        color: Colors.orangeAccent,
                        size: 50,
                      ),
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
                        height: carSize,
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
