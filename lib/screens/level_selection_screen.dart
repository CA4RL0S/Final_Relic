import 'package:darkness_dungeon/screens/levels/level1.dart';
import 'package:darkness_dungeon/screens/levels/level2.dart';
import 'package:darkness_dungeon/screens/levels/level3.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final PlayerInventory _inventory = PlayerInventory();
  bool _isLoading = true;
  late PageController _pageController;
  int _currentPage = 0;

  // Datos de los niveles
  final List<Map<String, dynamic>> _levels = [
    {
      'number': 1,
      'title': 'LA CRIPTA',
      'subtitle': 'El despertar del héroe',
      'icon': Icons.castle_outlined,
      'color': Colors.deepPurple,
      'screen': const Level1(),
    },
    {
      'number': 2,
      'title': 'EL BOSQUE',
      'subtitle': 'Sombras entre árboles',
      'icon': Icons.forest_outlined,
      'color': Colors.green,
      'screen': const Level2(),
    },
    {
      'number': 3,
      'title': 'VOLCÁN',
      'subtitle': 'Fuego y cenizas',
      'icon': Icons.whatshot,
      'color': Colors.deepOrange,
      'screen': const Level3(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75, initialPage: 0);
    _loadProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    await _inventory.loadInventory();
    setState(() {
      _isLoading = false;
      // Auto-scroll al último nivel desbloqueado (opcional)
      int maxLevel = _inventory.maxLevelReached;
      int targetPage = min(maxLevel - 1, _levels.length - 1);
      if (targetPage > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF1A1A2E), // Azul muy oscuro
              Colors.black,
            ],
            radius: 1.5,
            center: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Colors.deepPurpleAccent))
                    : _buildCarousel(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Column(
            children: [
              const Text(
                'MUNDO',
                style: TextStyle(
                  fontFamily: 'Normal',
                  color: Colors.white54,
                  fontSize: 16,
                  letterSpacing: 4,
                ),
              ),
              Text(
                _levels[_currentPage]['title'],
                style: const TextStyle(
                  fontFamily: 'Normal',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40), // Balance
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // PageView principal
            PageView.builder(
              controller: _pageController,
              itemCount: _levels.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    } else {
                      // Estado inicial o fallback
                      value = index == _currentPage ? 1.0 : 0.7;
                    }

                    final curve = Curves.easeOut.transform(value);

                    // Calculate dynamic sizes
                    // Use 80% of available height for the active card
                    final double maxHeight = constraints.maxHeight * 0.8;
                    // Use 70% of available width for the active card, but cap it to maintain aspect ratio if needed
                    final double maxWidth = constraints.maxWidth * 0.7;

                    return Center(
                      child: SizedBox(
                        height: curve * maxHeight, // Altura dinámica
                        width: curve * maxWidth, // Ancho dinámico
                        child: child,
                      ),
                    );
                  },
                  child: _buildLevelCard(index),
                );
              },
            ),

            // Flecha Izquierda
            if (_currentPage > 0)
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildArrowButton(
                    icon: Icons.arrow_back_ios_new,
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),

            // Flecha Derecha
            if (_currentPage < _levels.length - 1)
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildArrowButton(
                    icon: Icons.arrow_forward_ios,
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.deepPurpleAccent.withOpacity(0.8),
                  Colors.deepPurple.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelCard(int index) {
    final levelData = _levels[index];
    final int levelNumber = levelData['number'];
    final bool isLocked = _inventory.maxLevelReached < levelNumber;
    final Color color = levelData['color'];

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Nivel bloqueado! Completa el anterior.'),
              backgroundColor: Colors.red[900],
              duration: const Duration(seconds: 1),
            ),
          );
        } else if (levelData['screen'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => levelData['screen']),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isLocked ? Colors.black54 : color.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Fondo con gradiente
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isLocked
                        ? [Colors.grey[800]!, Colors.black]
                        : [color, Colors.black],
                  ),
                ),
              ),

              // Icono Gigante de fondo
              Positioned(
                right: -40,
                top: -40,
                child: Icon(
                  levelData['icon'],
                  size: 250,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),

              // Contenido Central
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Círculo del Nivel
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isLocked ? Colors.grey : Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            if (!isLocked)
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 20,
                              ),
                          ],
                        ),
                        child: Center(
                          child: isLocked
                              ? const Icon(Icons.lock,
                                  size: 40, color: Colors.grey)
                              : Text(
                                  '$levelNumber',
                                  style: const TextStyle(
                                    fontFamily: 'Normal',
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Título y Subtítulo
                      Text(
                        levelData['title'],
                        style: TextStyle(
                          fontFamily: 'Normal',
                          fontSize: 28,
                          color: isLocked ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        levelData['subtitle'],
                        style: TextStyle(
                          fontFamily: 'Normal',
                          fontSize: 16,
                          color: isLocked ? Colors.grey[600] : Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Botón Jugar (Solo si no está bloqueado)
                      if (!isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            'JUGAR',
                            style: TextStyle(
                              fontFamily: 'Normal',
                              color: color, // Color del tema del nivel
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
