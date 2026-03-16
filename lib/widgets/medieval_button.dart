import 'package:flutter/material.dart';

class MedievalButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color baseColor;
  final bool isSmall;
  final double? width;

  const MedievalButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.baseColor = Colors.deepPurple,
    this.isSmall = false,
    this.width,
  }) : super(key: key);

  @override
  State<MedievalButton> createState() => _MedievalButtonState();
}

class _MedievalButtonState extends State<MedievalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  // OPTIMIZADO: Cachear colores derivados
  late Color _darkColor;
  late Color _lightColor;
  late Color _shadowColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _computeColors();
  }

  @override
  void didUpdateWidget(MedievalButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseColor != widget.baseColor) {
      _computeColors();
    }
  }

  void _computeColors() {
    final hsl = HSLColor.fromColor(widget.baseColor);
    _darkColor = hsl.withLightness(0.3).toColor();
    _lightColor = hsl.withLightness(0.6).toColor();
    _shadowColor = hsl.withLightness(0.15).toColor().withOpacity(0.6);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.isSmall ? 45.0 : 60.0;
    final fontSize = widget.isSmall ? 16.0 : 22.0;
    final iconSize = widget.isSmall ? 20.0 : 28.0;
    final horizontalPadding = widget.isSmall ? 16.0 : 24.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0x33FFFFFF), // 0.2 opacity white
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _shadowColor,
                offset: _isPressed ? const Offset(0, 2) : const Offset(0, 6),
                blurRadius: _isPressed ? 2 : 0,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_lightColor, widget.baseColor, _darkColor],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: iconSize,
                  color: const Color(0xE6FFFFFF), // 0.9 opacity white
                ),
                SizedBox(width: widget.isSmall ? 8 : 12),
              ],
              Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Normal',
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: const [
                    Shadow(
                      color: Color(0x80000000), // 0.5 opacity black
                      offset: Offset(1, 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
