import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/screens/level_selection_screen.dart';
import 'package:darkness_dungeon/shop/shop_screen.dart';
import 'package:darkness_dungeon/util/custom_sprite_animation_widget.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/localization/strings_location.dart';
import 'package:darkness_dungeon/util/player_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:darkness_dungeon/services/ad_service.dart';
import 'package:darkness_dungeon/services/auth_service.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:darkness_dungeon/widgets/medieval_button.dart';
import 'package:darkness_dungeon/screens/skin_selector_screen.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  final ValueNotifier<int> _currentPositionNotifier = ValueNotifier<int>(0);
  late async.Timer _timer;
  late AnimationController _animController;

  // Partículas: usar AnimationController propio + CustomPainter
  late AnimationController _particleController;
  late List<_Particle> _particleData;

  List<Future<SpriteAnimation>> sprites = [
    PlayerSpriteSheet.idleRight(),
    EnemySpriteSheet.goblinIdleRight(),
    EnemySpriteSheet.impIdleRight(),
    EnemySpriteSheet.miniBossIdleRight(),
    EnemySpriteSheet.bossIdleRight(),
  ];

  @override
  void initState() {
    super.initState();
    Sounds.playBackgroundSound();
    startTimer();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Partículas con su propio controller (no hace setState)
    final rng = Random();
    _particleData = List.generate(10, (_) => _Particle(rng));
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _timer.cancel();
    _particleController.dispose();
    _animController.dispose();
    _currentPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO ATMOSFÉRICO (const — nunca se reconstruye)
          const _MenuBackground(),

          // 2. PARTÍCULAS (CustomPainter con su propio repaint)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ParticlePainter(_particleData, _particleController),
              ),
            ),
          ),

          // 3. VIÑETA (const)
          const _Vignette(),

          // 4. CONTENIDO PRINCIPAL
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: isSmallScreen ? 15 : 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // TÍTULO (Responsive)
                      _buildTitleResponsive(
                        isLandscape ? 26.0 : (isSmallScreen ? 34.0 : 42.0),
                        isLandscape ? 48.0 : (isSmallScreen ? 54.0 : 72.0),
                      ),

                      SizedBox(
                          height: isLandscape ? 8 : (isSmallScreen ? 20 : 30)),

                      // PERSONAJE ANIMADO (Responsive)
                      if (sprites.isNotEmpty)
                        _buildAnimatedCharacterResponsive(
                          isLandscape ? 60.0 : (isSmallScreen ? 80.0 : 120.0),
                        ),

                      SizedBox(
                          height: isLandscape ? 20 : (isSmallScreen ? 25 : 40)),

                      // BOTÓN JUGAR (Principal)
                      MedievalButton(
                        label: getString('play_cap'),
                        icon: Icons.play_arrow_rounded,
                        baseColor: const Color(0xFF6A1B9A), // Purple accent
                        width: isSmallScreen ? 220 : 260,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LevelSelectionScreen()),
                          );
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 25),

                      // BOTONES SECUNDARIOS (Responsive)
                      _buildSecondaryButtonsRow(isSmallScreen),

                      SizedBox(height: isSmallScreen ? 10 : 20),

                      // Copyright / Version footer
                      Text(
                        "v1.3.6 - Final Relic Team",
                        style: TextStyle(
                            fontFamily: 'Normal',
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 10),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // OPTIMIZADO: Título responsive sin ScrollView
  Widget _buildTitleResponsive(double size1, double size2) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "FINAL",
          style: TextStyle(
            color: const Color(0xFFB0BEC5), // Silver/Grey
            fontFamily: 'Normal',
            fontSize: size1,
            letterSpacing: size1 * 0.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 0,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            // Borde del texto (Stroke)
            Text(
              "RELIC",
              style: TextStyle(
                fontFamily: 'Normal',
                fontSize: size2,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = const Color(0xFF3E2723), // Dark brown outline
              ),
            ),
            // Relleno del texto (Fill con gradiente simulado por color sólido brillante)
            Text(
              "RELIC",
              style: TextStyle(
                color: const Color(0xFFFFC107), // Gold
                fontFamily: 'Normal',
                fontSize: size2,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.orange.withOpacity(0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // OPTIMIZADO: Personaje responsive
  Widget _buildAnimatedCharacterResponsive(double size) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPositionNotifier,
      builder: (context, currentPosition, child) {
        return AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animController.value * 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow de fondo (detrás del personaje)
                  Container(
                    height: size * 1.2,
                    width: size * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.purpleAccent.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: size,
                    width: size,
                    child: CustomSpriteAnimationWidget(
                      animation: sprites[currentPosition],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // OPTIMIZADO: Botones secundarios responsive usando MedievalButton
  Widget _buildSecondaryButtonsRow(bool isSmallScreen) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        MedievalButton(
          label: 'Tienda',
          icon: Icons.shopping_cart,
          baseColor: const Color(0xFFE65100), // Orange dark
          isSmall: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShopScreen()),
            );
          },
        ),
        MedievalButton(
          label: 'Skins',
          icon: Icons.checkroom,
          baseColor: const Color(0xFF6A1B9A), // Purple
          isSmall: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SkinSelectorScreen()),
            );
          },
        ),
        MedievalButton(
          label: 'Perfil',
          icon: Icons.person,
          baseColor: const Color(0xFF1565C0), // Blue dark
          isSmall: true,
          onPressed: _showProfileDialog,
        ),
        MedievalButton(
          label: '+100 💰',
          icon: Icons.video_library,
          baseColor: const Color(0xFF2E7D32), // Green dark
          isSmall: true,
          onPressed: _showRewardAd,
        ),
      ],
    );
  }

  void _showRewardAd() {
    if (AdService().isRewardedLoaded) {
      AdService().showRewardedAd(
        onRewardEarned: (amount) async {
          // Dar 100 monedas al usuario
          await PlayerInventory().addCoins(100);

          // Mostrar mensaje de éxito
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 10),
                    const Text(
                      '¡Has ganado 100 monedas! 💰',
                      style: TextStyle(
                        fontFamily: 'Normal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green[700],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Anuncio no disponible, intenta más tarde',
            style: TextStyle(fontFamily: 'Normal'),
          ),
          backgroundColor: Colors.orange[900],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showProfileDialog() {
    final user = AuthService().currentUser;
    final isGuest = AuthService().isAnonymous;
    final displayName = isGuest ? 'Invitado' : (user?.email ?? 'Usuario');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: const Color(0xFFFFC107).withOpacity(0.3), width: 2),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isGuest
                      ? [Colors.grey, Colors.grey[700]!]
                      : [const Color(0xFFFFC107), const Color(0xFFFF9800)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGuest ? Icons.person_outline : Icons.person,
                color: isGuest ? Colors.white : Colors.black87,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Normal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Normal',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isGuest
                  ? 'Tu progreso solo se guarda localmente'
                  : 'Tu progreso se sincroniza en la nube',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontFamily: 'Normal',
                fontSize: 12,
              ),
            ),
            if (isGuest) ...[
              const SizedBox(height: 16),
              Text(
                '⚠️ Crea una cuenta para no perder tu progreso',
                style: TextStyle(
                  color: Colors.orange[300],
                  fontFamily: 'Normal',
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CERRAR',
              style: TextStyle(
                color: Colors.white54,
                fontFamily: 'Normal',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              await AuthService().signOut();
              // AuthGate en main.dart se encargará de la navegación
            },
            child: const Text(
              'CERRAR SESIÓN',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Normal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    // OPTIMIZADO: Actualizar solo el ValueNotifier en lugar de setState
    _timer = async.Timer.periodic(const Duration(seconds: 2), (timer) {
      _currentPositionNotifier.value++;
      if (_currentPositionNotifier.value > sprites.length - 1) {
        _currentPositionNotifier.value = 0;
      }
    });
  }
}

// ============ WIDGETS CONST EXTRAÍDOS (nunca se reconstruyen) ============

class _MenuBackground extends StatelessWidget {
  const _MenuBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF0F0F1A),
          ],
          radius: 1.0,
          center: Alignment.center,
        ),
      ),
    );
  }
}

class _Vignette extends StatelessWidget {
  const _Vignette();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              Color(0x99000000), // 0.6 opacity black
            ],
            stops: [0.6, 1.0],
            radius: 1.2,
          ),
        ),
      ),
    );
  }
}

// ============ SISTEMA DE PARTÍCULAS OPTIMIZADO ============

class _Particle {
  double x;
  double y;
  final double size;
  final double speed;

  _Particle(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        size = 2.0 + rng.nextInt(3).toDouble(),
        speed = 0.002 + rng.nextDouble() * 0.003;

  void update() {
    y -= speed * 0.1;
    if (y < 0) {
      y = 1.0;
      // Use a simple deterministic drift instead of Random per frame
      x = (x + 0.37) % 1.0;
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  static final Paint _paint = Paint()
    ..color = const Color(0x59FFC107); // amber 35%

  _ParticlePainter(this.particles, Listenable controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      p.update();
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size / 2,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
