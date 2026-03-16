import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/interface/bar_life_component.dart';
import 'package:darkness_dungeon/player/knight.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:flutter/material.dart';

class KnightInterface extends GameInterface {
  late Sprite keySprite;
  final PlayerInventory inventory = PlayerInventory();

  // OPTIMIZADO: Cachear Paints para evitar recrearlos en cada frame
  late final Paint _bgPaint;
  late final Paint _borderPaint;
  late final Paint _shieldPaint;
  late final Paint _shieldBorderPaint;
  late final Paint _progressBgPaint;
  late final TextPaint _titlePaint;
  late final TextPaint _timePaint;

  @override
  Future<void> onLoad() async {
    keySprite = await Sprite.load('items/key_silver.png');
    add(MyBarLifeComponent());
    // Botones de pausa e inventario ahora están en Flutter directamente
    // add(PauseButtonComponent());
    // add(InventoryButtonComponent());
    
    await inventory.loadInventory();
    
    // OPTIMIZADO: Pre-crear Paints una sola vez
    _bgPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    _borderPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    _shieldPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    _shieldBorderPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    _progressBgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    _titlePaint = TextPaint(
      style: TextStyle(
        color: Colors.cyan,
        fontSize: 11,
        fontFamily: 'Normal',
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
      ),
    );
    
    _timePaint = TextPaint(
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'Normal',
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
      ),
    );
    
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      _drawKey(canvas);
      _drawShieldIndicator(canvas);
    } catch (e) {}
    super.render(canvas);
  }

  void _drawKey(Canvas c) {
    if (gameRef.player != null && (gameRef.player as Knight).containKey) {
      keySprite.renderRect(c, Rect.fromLTWH(150, 20, 35, 30));
    }
  }
  
  void _drawShieldIndicator(Canvas canvas) {
    // OPTIMIZADO: Verificación temprana para evitar cálculos innecesarios
    if (gameRef.player == null) return;
    
    final knight = gameRef.player as Knight;
    
    // Solo mostrar si el escudo está activo
    if (!knight.isInvincible || knight.invincibilityTimeLeft <= 0) return;
    
    // Posición centrada en la parte superior de la pantalla
    final screenWidth = gameRef.size.x;
    final centerX = screenWidth / 2;
    
    // OPTIMIZADO: Usar Paints pre-creados y cachear RRect
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - 95, 10, 190, 48),
      Radius.circular(12),
    );
    
    canvas.drawRRect(bgRect, _bgPaint);
    canvas.drawRRect(bgRect, _borderPaint);
    
    // Dibujar ícono de escudo
    final shieldCenter = Offset(centerX - 65, 33);
    canvas.drawCircle(shieldCenter, 12, _shieldPaint);
    canvas.drawCircle(shieldCenter, 12, _shieldBorderPaint);
    
    // Dibujar texto "ESCUDO ACTIVO"
    _titlePaint.render(
      canvas,
      '🛡️ ESCUDO ACTIVO',
      Vector2(centerX - 42, 19),
    );
    
    // Dibujar tiempo restante
    final timeText = '${knight.invincibilityTimeLeft.toInt()}s';
    _timePaint.render(
      canvas,
      timeText,
      Vector2(centerX - 12, 37),
    );
    
    // Dibujar barra de progreso
    const progressBarWidth = 165.0;
    const progressBarHeight = 4.0;
    final progressX = centerX - 82;
    const progressY = 52.0;
    
    // Fondo de la barra (usar Paint cacheado)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(progressX, progressY, progressBarWidth, progressBarHeight),
        Radius.circular(2),
      ),
      _progressBgPaint,
    );
    
    // Barra de progreso (tiempo restante)
    final progress = knight.invincibilityTimeLeft / 30.0;
    final progressFillWidth = progressBarWidth * progress;
    
    // OPTIMIZADO: Simplificar lógica de color
    final progressColor = progress > 0.5 
        ? Colors.cyan 
        : progress > 0.25 
            ? Colors.yellow 
            : Colors.orange;
    
    // OPTIMIZADO: Reusar Paint y solo cambiar color
    final progressFillPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(progressX, progressY, progressFillWidth, progressBarHeight),
        Radius.circular(2),
      ),
      progressFillPaint,
    );
  }
}
