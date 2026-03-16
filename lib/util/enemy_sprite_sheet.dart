import 'package:bonfire/bonfire.dart';

class EnemySpriteSheet {
  static Future<SpriteAnimation> enemyAttackEffectBottom() =>
      SpriteAnimation.load(
        'enemy/atack_effect_bottom.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> enemyAttackEffectLeft() =>
      SpriteAnimation.load(
        'enemy/atack_effect_left.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> enemyAttackEffectRight() =>
      SpriteAnimation.load(
        'enemy/atack_effect_right.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> enemyAttackEffectTop() => SpriteAnimation.load(
        'enemy/atack_effect_top.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> bossIdleRight() => SpriteAnimation.load(
        'enemy/boss/boss_idle.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(32, 36),
        ),
      );

  static SimpleDirectionAnimation bossAnimations() => SimpleDirectionAnimation(
        idleLeft: SpriteAnimation.load(
          'enemy/boss/boss_idle_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(32, 36),
          ),
        ),
        idleRight: bossIdleRight(),
        runLeft: SpriteAnimation.load(
          'enemy/boss/boss_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(32, 36),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/boss/boss_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(32, 36),
          ),
        ),
      );

  static Future<SpriteAnimation> goblinIdleRight() => SpriteAnimation.load(
        'enemy/goblin/goblin_idle.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static SimpleDirectionAnimation goblinAnimations() =>
      SimpleDirectionAnimation(
        idleLeft: SpriteAnimation.load(
          'enemy/goblin/goblin_idle_left.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        idleRight: SpriteAnimation.load(
          'enemy/goblin/goblin_idle.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runLeft: SpriteAnimation.load(
          'enemy/goblin/goblin_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/goblin/goblin_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
      );

  static Future<SpriteAnimation> impIdleRight() => SpriteAnimation.load(
        'enemy/imp/imp_idle.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static SimpleDirectionAnimation impAnimations() => SimpleDirectionAnimation(
        idleLeft: SpriteAnimation.load(
          'enemy/imp/imp_idle_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        idleRight: SpriteAnimation.load(
          'enemy/imp/imp_idle.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runLeft: SpriteAnimation.load(
          'enemy/imp/imp_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/imp/imp_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
      );

  static Future<SpriteAnimation> miniBossIdleRight() => SpriteAnimation.load(
        'enemy/mini_boss/mini_boss_idle.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(16, 24),
        ),
      );

  static SimpleDirectionAnimation miniBossAnimations() =>
      SimpleDirectionAnimation(
        idleLeft: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_idle_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
        idleRight: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_idle.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
        runLeft: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
      );

  // ========== MiniL2 Animations (Level 2 Enemy) ==========
  
  // Idle: 256x256 (4x4) -> 64x64 frames
  static Future<SpriteAnimation> miniL2IdleUp() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up (Corrected)
        ),
      );

  static Future<SpriteAnimation> miniL2IdleDown() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down (Corrected)
        ),
      );

  static Future<SpriteAnimation> miniL2IdleLeft() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> miniL2IdleRight() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  // Run: 512x256 (8x4) -> 64x64 frames
  static Future<SpriteAnimation> miniL2RunUp() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up (Corrected)
        ),
      );

  static Future<SpriteAnimation> miniL2RunDown() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down (Corrected)
        ),
      );

  static Future<SpriteAnimation> miniL2RunLeft() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> miniL2RunRight() => SpriteAnimation.load(
        'enemy/miniL2/miniL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  // Attack: 768x256 (12x4) -> 64x64 frames
  static Future<SpriteAnimation> miniL2AttackUp() => SpriteAnimation.load(
        'enemy/miniL2/mini_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up (Corrected)
        ),
      );

  static Future<SpriteAnimation> miniL2AttackDown() => SpriteAnimation.load(
        'enemy/miniL2/mini_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down (Corrected)
        ),
      );

  static Future<SpriteAnimation> miniL2AttackLeft() => SpriteAnimation.load(
        'enemy/miniL2/mini_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> miniL2AttackRight() => SpriteAnimation.load(
        'enemy/miniL2/mini_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  static SimpleDirectionAnimation miniL2Animations() => SimpleDirectionAnimation(
        idleUp: miniL2IdleUp(),
        idleDown: miniL2IdleDown(),
        idleLeft: miniL2IdleLeft(),
        idleRight: miniL2IdleRight(),
        runUp: miniL2RunUp(),
        runDown: miniL2RunDown(),
        runLeft: miniL2RunLeft(),
        runRight: miniL2RunRight(),
      );


  // ========== MediumL2 Animations (Level 2 Enemy) ==========
  
  // Idle: 256x256 (4x4) -> 64x64 frames
  static Future<SpriteAnimation> mediumL2IdleUp() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up
        ),
      );

  static Future<SpriteAnimation> mediumL2IdleDown() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down
        ),
      );

  static Future<SpriteAnimation> mediumL2IdleLeft() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> mediumL2IdleRight() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  // Run: 512x256 (8x4) -> 64x64 frames
  static Future<SpriteAnimation> mediumL2RunUp() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up
        ),
      );

  static Future<SpriteAnimation> mediumL2RunDown() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down
        ),
      );

  static Future<SpriteAnimation> mediumL2RunLeft() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> mediumL2RunRight() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  // Attack: Assuming 768x256 (12x4) -> 64x64 frames (Same as MiniL2)
  static Future<SpriteAnimation> mediumL2AttackUp() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up
        ),
      );

  static Future<SpriteAnimation> mediumL2AttackDown() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down
        ),
      );

  static Future<SpriteAnimation> mediumL2AttackLeft() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> mediumL2AttackRight() => SpriteAnimation.load(
        'enemy/mediumL2/mediumL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  static SimpleDirectionAnimation mediumL2Animations() => SimpleDirectionAnimation(
        idleUp: mediumL2IdleUp(),
        idleDown: mediumL2IdleDown(),
        idleLeft: mediumL2IdleLeft(),
        idleRight: mediumL2IdleRight(),
        runUp: mediumL2RunUp(),
        runDown: mediumL2RunDown(),
        runLeft: mediumL2RunLeft(),
        runRight: mediumL2RunRight(),
      );

  // ========== BossL2 Animations (Level 2 Boss) ==========
  
  // Idle: 256x256 (4x4) -> 64x64 frames
  static Future<SpriteAnimation> bossL2IdleUp() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up
        ),
      );

  static Future<SpriteAnimation> bossL2IdleDown() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down
        ),
      );

  static Future<SpriteAnimation> bossL2IdleLeft() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> bossL2IdleRight() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Idle_full.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  // Run: 512x256 (8x4) -> 64x64 frames
  static Future<SpriteAnimation> bossL2RunUp() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up
        ),
      );

  static Future<SpriteAnimation> bossL2RunDown() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down
        ),
      );

  static Future<SpriteAnimation> bossL2RunLeft() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> bossL2RunRight() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Run_full.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  // Attack: Assuming 768x256 (12x4) -> 64x64 frames
  static Future<SpriteAnimation> bossL2AttackUp() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 64), // Row 2 - Up
        ),
      );

  static Future<SpriteAnimation> bossL2AttackDown() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 0), // Row 1 - Down
        ),
      );

  static Future<SpriteAnimation> bossL2AttackLeft() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 128), // Row 3 - Left
        ),
      );

  static Future<SpriteAnimation> bossL2AttackRight() => SpriteAnimation.load(
        'enemy/bossL2/bossL2_Attack_full.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.08,
          textureSize: Vector2(64, 64),
          texturePosition: Vector2(0, 192), // Row 4 - Right
        ),
      );

  static SimpleDirectionAnimation bossL2Animations() => SimpleDirectionAnimation(
        idleUp: bossL2IdleUp(),
        idleDown: bossL2IdleDown(),
        idleLeft: bossL2IdleLeft(),
        idleRight: bossL2IdleRight(),
        runUp: bossL2RunUp(),
        runDown: bossL2RunDown(),
        runLeft: bossL2RunLeft(),
        runRight: bossL2RunRight(),
      );

  // ========== MiniL3 Animations (Level 3 Enemy) ==========
  
  // Idle Right
  static Future<SpriteAnimation> miniL3IdleRight() => SpriteAnimation.load(
        'enemy/miniL3/miniL3_idle.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.15,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Idle Left (New file)
  static Future<SpriteAnimation> miniL3IdleLeft() => SpriteAnimation.load(
        'enemy/miniL3/miniL3_idle_left.png', // Archivo específico para izquierda
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.15,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Run Right
  static Future<SpriteAnimation> miniL3RunRight() => SpriteAnimation.load(
        'enemy/miniL3/mniL3_Run.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Run Left (New file)
  static Future<SpriteAnimation> miniL3RunLeft() => SpriteAnimation.load(
        'enemy/miniL3/mniL3_Run_left.png', // Archivo específico para izquierda
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  static SimpleDirectionAnimation miniL3Animations() => SimpleDirectionAnimation(
        idleRight: miniL3IdleRight(),
        idleLeft: miniL3IdleLeft(),
        idleUp: miniL3IdleRight(),
        idleDown: miniL3IdleRight(),
        runRight: miniL3RunRight(),
        runLeft: miniL3RunLeft(),
        runUp: miniL3RunRight(),
        runDown: miniL3RunRight(),
      );

  // ========== MediumL3 Animations (Level 3 Enemy) ==========
  
  // Idle Right
  static Future<SpriteAnimation> mediumL3IdleRight() => SpriteAnimation.load(
        'enemy/meduimL3/meduimL3_Idle.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.15,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Idle Left (New file)
  static Future<SpriteAnimation> mediumL3IdleLeft() => SpriteAnimation.load(
        'enemy/meduimL3/meduimL3_Idle_left.png', // Archivo específico para izquierda
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.15,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Run Right
  static Future<SpriteAnimation> mediumL3RunRight() => SpriteAnimation.load(
        'enemy/meduimL3/meduimL3_Run.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Run Left (New file)
  static Future<SpriteAnimation> mediumL3RunLeft() => SpriteAnimation.load(
        'enemy/meduimL3/meduimL3_Run_left.png', // Archivo específico para izquierda
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  static SimpleDirectionAnimation mediumL3Animations() => SimpleDirectionAnimation(
        idleRight: mediumL3IdleRight(),
        idleLeft: mediumL3IdleLeft(),
        idleUp: mediumL3IdleRight(),
        idleDown: mediumL3IdleRight(),
        runRight: mediumL3RunRight(),
        runLeft: mediumL3RunLeft(),
        runUp: mediumL3RunRight(),
        runDown: mediumL3RunRight(),
      );

  // ========== BossL3 Animations (Level 3 Boss) ==========
  
  // Idle Right
  static Future<SpriteAnimation> bossL3IdleRight() => SpriteAnimation.load(
        'enemy/bossL3/bossL3_Idle.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.15,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Idle Left (New file)
  static Future<SpriteAnimation> bossL3IdleLeft() => SpriteAnimation.load(
        'enemy/bossL3/bossL3_Idle_left.png', // Archivo específico para izquierda
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.15,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Run Right
  static Future<SpriteAnimation> bossL3RunRight() => SpriteAnimation.load(
        'enemy/bossL3/bossL3_Run.png',
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  // Run Left (New file)
  static Future<SpriteAnimation> bossL3RunLeft() => SpriteAnimation.load(
        'enemy/bossL3/bossL3_Run_left.png', // Archivo específico para izquierda
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(128, 128),
          texturePosition: Vector2(0, 0),
        ),
      );

  static SimpleDirectionAnimation bossL3Animations() => SimpleDirectionAnimation(
        idleRight: bossL3IdleRight(),
        idleLeft: bossL3IdleLeft(),
        idleUp: bossL3IdleRight(),
        idleDown: bossL3IdleRight(),
        runRight: bossL3RunRight(),
        runLeft: bossL3RunLeft(),
        runUp: bossL3RunRight(),
        runDown: bossL3RunRight(),
      );
}
