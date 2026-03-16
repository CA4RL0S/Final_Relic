import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/constants/game_constants.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/functions.dart';
import 'package:darkness_dungeon/util/game_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:flutter/material.dart';

/// MiniL2 - Enemigo pequeño del Nivel 2
/// 
/// Este enemigo tiene las mismas mecánicas que Imp del nivel 1,
/// pero con sprites diferentes y animaciones más fluidas.
class MiniL2 extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 10;

  MiniL2(this.initPosition)
      : super(
          animation: EnemySpriteSheet.miniL2Animations(),
          position: initPosition,
          size: Vector2(64, 64), // Match 64x64 sprite size
          speed: GameConstants.tileSize * 2,
          life: 80,
        ) {
    // Barra de vida sin números
    setupLifeBar(
      size: Vector2(width * 0.5, 3),
      borderRadius: BorderRadius.circular(2),
      borderWidth: 1,
      showLifeText: false,
    );
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(
          valueByTileSize(6),
          valueByTileSize(6),
        ),
        position: Vector2(
          valueByTileSize(3),
          valueByTileSize(5),
        ),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    seeAndMoveToPlayer(
      radiusVision: GameConstants.tileSize * 5,
      closePlayer: (player) {
        execAttack();
      },
    );
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2(64, 64),
      damage: attack,
      interval: 800,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void onDie() {
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.smokeExplosion(),
        position: position,
        size: Vector2(32, 32),
        loop: false,
      ),
    );
    removeFromParent();
    super.onDie();
  }

  @override
  void onReceiveDamage(AttackOriginEnum attacker, double damage, dynamic id) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(3),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.onReceiveDamage(attacker, damage, id);
  }
}
