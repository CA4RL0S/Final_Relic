import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static Future<SpriteAnimation> idleRight() => SpriteAnimation.load(
        'player/idle_animation.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  static Future<SpriteAnimation> heroAttack() => SpriteAnimation.load(
        'player/attack_animation.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  static Future<SpriteAnimation> attackEffectBottom() => SpriteAnimation.load(
        'player/atack_effect_bottom.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> attackEffectLeft() => SpriteAnimation.load(
        'player/atack_effect_left.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> attackEffectRight() => SpriteAnimation.load(
        'player/atack_effect_right.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> attackEffectTop() => SpriteAnimation.load(
        'player/atack_effect_top.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  // ============ SISTEMA DE SKINS ============

  /// Animaciones del caballero original (skin 'knight')
  static Future<SpriteAnimation> knightIdleRight() => SpriteAnimation.load(
        'player/knight_idle.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> knightRunRight() => SpriteAnimation.load(
        'player/knight_run.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  /// Devuelve las animaciones según el skinId
  static SimpleDirectionAnimation playerAnimations(
      {String skinId = 'default'}) {
    switch (skinId) {
      case 'knight':
        return SimpleDirectionAnimation(
          idleRight: knightIdleRight(),
          runRight: knightRunRight(),
          enabledFlipX: true,
        );
      default:
        return SimpleDirectionAnimation(
          idleRight: idleRight(),
          runRight: SpriteAnimation.load(
            'player/walk_animation.png',
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.1,
              textureSize: Vector2(32, 32),
            ),
          ),
          enabledFlipX: true,
        );
    }
  }
}
