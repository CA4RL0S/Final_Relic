import 'package:darkness_dungeon/services/auth_service.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _showForm = false;
  bool _isLoginMode = true; // true = login, false = register

  late AnimationController _particleController;
  late List<_LoginParticle> _particles;
  late AnimationController _titleController;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(12, (_) => _LoginParticle(rng));
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _particleController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Normal')),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showError(String message) {
    setState(() {
      // Hacer mensajes de error más amigables
      if (message.contains('user-not-found')) {
        _errorMessage = 'No existe una cuenta con ese email';
      } else if (message.contains('wrong-password')) {
        _errorMessage = 'Contraseña incorrecta';
      } else if (message.contains('email-already-in-use')) {
        _errorMessage = 'Ya existe una cuenta con ese email';
      } else if (message.contains('weak-password')) {
        _errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      } else if (message.contains('invalid-email')) {
        _errorMessage = 'Email inválido';
      } else {
        _errorMessage = message;
      }
    });
  }

  Future<void> _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Por favor completa todos los campos');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLoginMode) {
        await AuthService().signInWithEmail(email, password);
        _showSuccessMessage('¡Sesión iniciada!');
      } else {
        await AuthService().registerWithEmail(email, password);
        _showSuccessMessage('¡Cuenta creada con éxito!');
      }
      await PlayerInventory().loadInventory();
      // Auth gate in main.dart will handle navigation
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthService().signInAnonymously();
      await PlayerInventory().loadInventory();
      _showSuccessMessage('¡Bienvenido, Guerrero!');
      // Auth gate in main.dart will handle navigation
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                painter: _LoginParticlePainter(_particles, _particleController),
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

          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),

                      // Título del juego
                      _buildTitle(),

                      const SizedBox(height: 10),

                      // Subtítulo
                      Text(
                        'Inicia tu aventura',
                        style: TextStyle(
                          fontFamily: 'Normal',
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Contenido dinámico
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:
                            _showForm ? _buildEmailForm() : _buildMainButtons(),
                      ),

                      const SizedBox(height: 20),
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

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'FINAL',
              style: TextStyle(
                color: const Color(0xFFB0BEC5),
                fontFamily: 'Normal',
                fontSize: 28,
                letterSpacing: 5.6,
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
                Text(
                  'RELIC',
                  style: TextStyle(
                    fontFamily: 'Normal',
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = const Color(0xFF3E2723),
                  ),
                ),
                Text(
                  'RELIC',
                  style: TextStyle(
                    color: const Color(0xFFFFC107),
                    fontFamily: 'Normal',
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.orange
                            .withOpacity(0.4 + _titleController.value * 0.3),
                        blurRadius: 20 + _titleController.value * 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainButtons() {
    return Column(
      key: const ValueKey('main_buttons'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón Crear Cuenta
        _buildPremiumButton(
          label: 'CREAR CUENTA',
          icon: Icons.person_add_rounded,
          gradient: const [Color(0xFFFFC107), Color(0xFFFF9800)],
          shadowColor: const Color(0xFFFFC107),
          onTap: () {
            setState(() {
              _showForm = true;
              _isLoginMode = false;
              _errorMessage = null;
            });
          },
        ),

        const SizedBox(height: 16),

        // Botón Iniciar Sesión
        _buildPremiumButton(
          label: 'INICIAR SESIÓN',
          icon: Icons.login_rounded,
          gradient: const [Color(0xFF6A1B9A), Color(0xFF4A148C)],
          shadowColor: const Color(0xFF6A1B9A),
          onTap: () {
            setState(() {
              _showForm = true;
              _isLoginMode = true;
              _errorMessage = null;
            });
          },
        ),

        const SizedBox(height: 32),

        // Divider
        Row(
          children: [
            Expanded(
                child: Divider(
                    color: Colors.white.withOpacity(0.15), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'O',
                style: TextStyle(
                  fontFamily: 'Normal',
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
                child: Divider(
                    color: Colors.white.withOpacity(0.15), thickness: 1)),
          ],
        ),

        const SizedBox(height: 24),

        // Jugar como invitado
        GestureDetector(
          onTap: _isLoading ? null : _handleGuestLogin,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline,
                    color: Colors.white.withOpacity(0.5), size: 22),
                const SizedBox(width: 10),
                Text(
                  'JUGAR COMO INVITADO',
                  style: TextStyle(
                    fontFamily: 'Normal',
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Nota
        Text(
          'El progreso de invitado solo se guarda localmente',
          style: TextStyle(
            fontFamily: 'Normal',
            fontSize: 11,
            color: Colors.white.withOpacity(0.25),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return Column(
      key: const ValueKey('email_form'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón volver
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showForm = false;
                _errorMessage = null;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_ios,
                    color: Colors.white.withOpacity(0.5), size: 16),
                Text(
                  'Volver',
                  style: TextStyle(
                    fontFamily: 'Normal',
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Título del form
        Text(
          _isLoginMode ? 'Iniciar Sesión' : 'Crear Cuenta',
          style: const TextStyle(
            fontFamily: 'Normal',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 24),

        // Email
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 16),

        // Password
        _buildTextField(
          controller: _passwordController,
          label: 'Contraseña',
          icon: Icons.lock_outline,
          obscureText: true,
        ),

        // Error
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[300], size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontFamily: 'Normal',
                      color: Colors.red[300],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Botón submit
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFC107)),
          )
        else
          _buildPremiumButton(
            label: _isLoginMode ? 'ENTRAR' : 'CREAR CUENTA',
            icon: _isLoginMode ? Icons.login_rounded : Icons.person_add,
            gradient: _isLoginMode
                ? const [Color(0xFF6A1B9A), Color(0xFF4A148C)]
                : const [Color(0xFFFFC107), Color(0xFFFF9800)],
            shadowColor: _isLoginMode
                ? const Color(0xFF6A1B9A)
                : const Color(0xFFFFC107),
            onTap: _handleEmailAuth,
          ),

        const SizedBox(height: 16),

        // Toggle login/register
        GestureDetector(
          onTap: () {
            setState(() {
              _isLoginMode = !_isLoginMode;
              _errorMessage = null;
            });
          },
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Normal',
                fontSize: 13,
                color: Colors.white.withOpacity(0.4),
              ),
              children: [
                TextSpan(
                    text: _isLoginMode
                        ? '¿No tienes cuenta? '
                        : '¿Ya tienes cuenta? '),
                TextSpan(
                  text: _isLoginMode ? 'Crear una' : 'Inicia sesión',
                  style: const TextStyle(
                    color: Color(0xFFFFC107),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontFamily: 'Normal'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontFamily: 'Normal',
        ),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.3)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFFC107)),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Widget _buildPremiumButton({
    required String label,
    required IconData icon,
    required List<Color> gradient,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Normal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Color(0x80000000),
                    offset: Offset(1, 1),
                    blurRadius: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ Partículas ============

class _LoginParticle {
  double x;
  double y;
  final double size;
  final double speed;

  _LoginParticle(Random rng)
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

class _LoginParticlePainter extends CustomPainter {
  final List<_LoginParticle> particles;
  static final Paint _paint = Paint()..color = const Color(0x59FFC107);

  _LoginParticlePainter(this.particles, Listenable controller)
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
  bool shouldRepaint(covariant _LoginParticlePainter oldDelegate) => true;
}
