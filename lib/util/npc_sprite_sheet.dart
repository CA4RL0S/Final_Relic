import 'package:bonfire/bonfire.dart';

class NpcSpriteSheet {
  static Future<SpriteAnimation> kidIdleLeft() => SpriteAnimation.load(
        'npc/kid_idle_left.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(16, 22),
        ),
      );

  static Future<SpriteAnimation> wizardIdleLeft() => SpriteAnimation.load(
        'npc/wizard_idle_left.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(16, 22),
        ),
      );

  static Future<SpriteAnimation> princessIdleLeft() => SpriteAnimation.load(
        'npc/princess.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(48, 40),
          texturePosition: Vector2(0, 40),
        ),
      );

  static Future<SpriteAnimation> oldManIdleLeft() => SpriteAnimation.load(
        'npc/old_man.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(16, 22),
        ),
      );

  static Future<SpriteAnimation> kidL2IdleLeft() => SpriteAnimation.load(
        'npc/kidL2/kidL2_left.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.2,
          textureSize: Vector2(880, 1216),
        ),
      );

  static Future<SpriteAnimation> kidL3IdleLeft() => SpriteAnimation.load(
        'npc/kidL3/kidL3.png', // Cambiado de kidL3_left.png a kidL3.png
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.2,
          textureSize: Vector2(880, 1216),
        ),
      );
}
