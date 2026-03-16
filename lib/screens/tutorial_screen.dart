import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _particleController;
  late List<_TutorialParticle> _particles;
  late AnimationController _pulseController;

  final List<_TutorialSlide> _slides = [
    _TutorialSlide(
      icon: Icons.shield_outlined,
      title: '¡Bienvenido, Guerrero!',
      description:
          'Has sido elegido para recuperar las reliquias antiguas.\nUna oscuridad se cierne sobre las mazmorras...',
      accentColor: const Color(0xFFFFC107),
    ),
    _TutorialSlide(
      icon: Icons.gamepad_outlined,
      title: 'Controles',
      description:
          '🕹️ Usa el joystick para moverte\n⚔️ Toca los botones para atacar\n🛡️ Elimina a todos los enemigos para avanzar',
      accentColor: const Color(0xFF42A5F5),
    ),
    _TutorialSlide(
      icon: Icons.store_outlined,
      title: 'Tienda y Monedas',
      description:
          '💰 Gana monedas derrotando enemigos\n🛒 Compra mejoras en la tienda\n🎬 Mira anuncios para ganar monedas extra',
      accentColor: const Color(0xFF66BB6A),
    ),
    _TutorialSlide(
      icon: Icons.auto_awesome,
      title: '¡Buena Suerte!',
      description:
          'Explora 3 mazmorras únicas, derrota jefes épicos\ny conviértete en la leyenda de Final Relic.',
      accentColor: const Color(0xFFAB47BC),
    ),
  ];

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(15, (_) => _TutorialParticle(rng));
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _completeTutorial() async {
    await PlayerInventory().markTutorialCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
                radius: 1.0,
                center: Alignment.center,
              ),
            ),
          ),

          // Partículas
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter:
                    _TutorialParticlePainter(_particles, _particleController),
              ),
            ),
          ),

          // Viñeta
          IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.transparent, Color(0x99000000)],
                  stops: [0.6, 1.0],
                  radius: 1.2,
                ),
              ),
            ),
          ),

          // Contenido
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: _completeTutorial,
                      child: Text(
                        'SALTAR',
                        style: TextStyle(
                          fontFamily: 'Normal',
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _buildSlide(_slides[index]);
                    },
                  ),
                ),

                // Indicadores + botón
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      // Dots
                      Row(
                        children: List.generate(
                          _slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _currentPage == index
                                  ? _slides[_currentPage].accentColor
                                  : Colors.white24,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Botón siguiente / comenzar
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = isLastPage
                              ? 1.0 + (_pulseController.value * 0.05)
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: isLastPage
                              ? _completeTutorial
                              : () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isLastPage ? 28 : 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isLastPage
                                    ? [
                                        const Color(0xFFFFC107),
                                        const Color(0xFFFF9800)
                                      ]
                                    : [
                                        _slides[_currentPage].accentColor,
                                        _slides[_currentPage]
                                            .accentColor
                                            .withOpacity(0.7),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: (isLastPage
                                          ? const Color(0xFFFFC107)
                                          : _slides[_currentPage].accentColor)
                                      .withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLastPage ? 'COMENZAR' : 'SIGUIENTE',
                                  style: const TextStyle(
                                    fontFamily: 'Normal',
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isLastPage
                                      ? Icons.play_arrow_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(_TutorialSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícono con glow
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  slide.accentColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: slide.accentColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: slide.accentColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                slide.icon,
                size: 50,
                color: slide.accentColor,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Título
          Text(
            slide.title,
            style: TextStyle(
              fontFamily: 'Normal',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: slide.accentColor,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: slide.accentColor.withOpacity(0.5),
                  blurRadius: 15,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Descripción
          Text(
            slide.description,
            style: TextStyle(
              fontFamily: 'Normal',
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============ Datos ============

class _TutorialSlide {
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;

  const _TutorialSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
  });
}

// ============ Partículas ============

class _TutorialParticle {
  double x;
  double y;
  final double size;
  final double speed;

  _TutorialParticle(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        size = 2.0 + rng.nextInt(3).toDouble(),
        speed = 0.002 + rng.nextDouble() * 0.003;

  void update() {
    y -= speed * 0.1;
    if (y < 0) {
      y = 1.0;
      x = (x + 0.37) % 1.0;
    }
  }
}

class _TutorialParticlePainter extends CustomPainter {
  final List<_TutorialParticle> particles;
  static final Paint _paint = Paint()
    ..color = const Color(0x59FFC107); // amber 35%

  _TutorialParticlePainter(this.particles, Listenable controller)
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
  bool shouldRepaint(covariant _TutorialParticlePainter oldDelegate) => true;
}
