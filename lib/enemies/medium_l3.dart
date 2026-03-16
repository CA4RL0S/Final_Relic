import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/constants/game_constants.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/functions.dart';
import 'package:darkness_dungeon/util/game_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:flutter/material.dart';

/// MediumL3 - Enemigo mediano del Nivel 3
/// 
/// Este enemigo tiene las mismas mecánicas que MediumL2,
/// pero para el Nivel 3. Puedes ajustar sus stats después.
class MediumL3 extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 50;
  bool _seePlayerClose = false;

  MediumL3(this.initPosition)
      : super(
          animation: EnemySpriteSheet.mediumL3Animations(),
          position: initPosition,
          size: Vector2(64, 64), // Reducido de 128 a 64
          speed: GameConstants.tileSize * 1.5,
          life: 150,
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
        size: Vector2(valueByTileSize(16), valueByTileSize(16)), // 32px
        position: Vector2(valueByTileSize(8), valueByTileSize(8)), // Centrado: (64-32)/2 = 16px
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _seePlayerClose = false;
    this.seePlayer(
      observed: (player) {
        _seePlayerClose = true;
        this.seeAndMoveToPlayer(
          closePlayer: (player) {
            execAttack();
          },
          radiusVision: GameConstants.tileSize * 3,
        );
      },
      radiusVision: GameConstants.tileSize * 3,
    );
    if (!_seePlayerClose) {
      this.seeAndMoveToAttackRange(
        positioned: (p) {
          execAttackRange();
        },
        radiusVision: GameConstants.tileSize * 5,
      );
    }
  }

  @override
  void onDie() {
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.smokeExplosion(),
        position: this.position,
        size: Vector2(32, 32),
        loop: false,
      ),
    );
    removeFromParent();
    super.onDie();
  }

  void execAttackRange() {
    this.simpleAttackRange(
      animation: GameSpriteSheet.fireBallAttackRight(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2.all(GameConstants.tileSize * 0.65),
      damage: attack,
      speed: speed * 2.5,
      execute: () {
        Sounds.attackRange();
      },
      onDestroy: () {
        Sounds.explosion();
      },
      collision: RectangleHitbox(
        size: Vector2(GameConstants.tileSize / 3, GameConstants.tileSize / 3),
        position: Vector2(10, 5),
      ),
    );
  }

  void execAttack() {
    this.simpleAttackMelee(
      size: Vector2.all(GameConstants.tileSize * 0.62),
      damage: attack / 3,
      interval: 300,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void onReceiveDamage(AttackOriginEnum attacker, double damage, dynamic id) {
    this.showDamage(
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
