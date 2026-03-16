import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/medium_l3.dart';
import 'package:darkness_dungeon/enemies/mini_l3.dart';
import 'package:darkness_dungeon/constants/game_constants.dart';
import 'package:darkness_dungeon/util/custom_sprite_animation_widget.dart';
import 'package:darkness_dungeon/util/enemy_sprite_sheet.dart';
import 'package:darkness_dungeon/util/functions.dart';
import 'package:darkness_dungeon/util/game_sprite_sheet.dart';
import 'package:darkness_dungeon/util/localization/strings_location.dart';
import 'package:darkness_dungeon/util/npc_sprite_sheet.dart';
import 'package:darkness_dungeon/util/player_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:darkness_dungeon/npc/kid_l3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// BossL3 - Jefe del Nivel 3
class BossL3 extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 40;

  bool addChild = false;
  bool firstSeePlayer = false;
  bool conversationFinished = false; // Nueva bandera para controlar ataques
  List<Enemy> childrenEnemy = [];

  BossL3(this.initPosition)
      : super(
          animation: EnemySpriteSheet.bossL3Animations(),
          position: initPosition,
          size: Vector2(96, 96),
          speed: GameConstants.tileSize * 2.5, // Aumentado de 1.5 a 2.5 (+67%)
          life: 300, // Aumentado de 200 a 300 (+50%)
        ) {
    attack = 60; // Aumentado de 40 a 60 (+50%)
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
        size: Vector2(valueByTileSize(24), valueByTileSize(24)),
        position: Vector2(valueByTileSize(12), valueByTileSize(12)),
      ),
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    drawBarSummonEnemy(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    if (!firstSeePlayer) {
      this.seePlayer(
        observed: (p) {
          firstSeePlayer = true;
          gameRef.camera.moveToTargetAnimated(
            target: this,
            zoom: 2,
            onComplete: _showConversation,
          );
        },
        radiusVision: GameConstants.tileSize * 6,
      );
    }

    // Solo atacar después de que termine la conversación inicial
    if (conversationFinished) {
      // Boss L3: Persigue al jugador mientras dispara
      this.seeAndMoveToPlayer(
        closePlayer: (player) {
          execAttack(); // Ataque melee cuando está cerca
        },
        radiusVision: GameConstants.tileSize * 6, // Radio amplio para perseguir
        runOnlyVisibleInScreen: false, // Persigue incluso fuera de pantalla
      );

      // Dispara bolas de fuego mientras persigue
      // Usa seePlayer en vez de seeAndMoveToAttackRange para no detenerse
      this.seePlayer(
        observed: (player) {
          execAttackRange(); // Dispara mientras se mueve
        },
        radiusVision: GameConstants.tileSize * 6,
      );
    }

    super.update(dt);
  }

  @override
  void onDie() {
    // KidL3 (la reina) ya está en el mapa, no necesita spawnearse
    
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.explosion(),
        position: position,
        size: Vector2(32, 32),
        loop: false,
      ),
    );
    
    for (int i = 0; i < childrenEnemy.length; i++) {
      final enemy = childrenEnemy[i];
      if (!enemy.isDead) {
        Future.delayed(Duration(milliseconds: i * 200), () {
          if (enemy.isMounted && !enemy.isDead) {
            enemy.onDie();
          }
        });
      }
    }
    
    removeFromParent();
    super.onDie();
  }

  void execAttack() {
    this.simpleAttackMelee(
      size: Vector2.all(GameConstants.tileSize * 0.62),
      damage: attack,
      interval: 1500,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        Sounds.attackEnemyMelee();
      },
    );
  }

  // Ataque de bolas de fuego rápido para el boss final
  void execAttackRange() {
    this.simpleAttackRange(
      animation: GameSpriteSheet.fireBallAttackRight(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2.all(GameConstants.tileSize * 0.7),
      damage: attack * 0.8, // 80% del daño melee
      speed: speed * 3, // Muy rápido
      interval: 400, // Dispara cada 400ms - MUY RÁPIDO
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

  void drawBarSummonEnemy(Canvas canvas) {
    double yPosition = 0;
    double widthBar = (width - 10) / 3;
    if (childrenEnemy.length < 1)
      canvas.drawLine(
          Offset(0, yPosition),
          Offset(widthBar, yPosition),
          Paint()
            ..color = Colors.orange
            ..strokeWidth = 1
            ..style = PaintingStyle.fill);

    double lastX = widthBar + 5;
    if (childrenEnemy.length < 2)
      canvas.drawLine(
          Offset(lastX, yPosition),
          Offset(lastX + widthBar, yPosition),
          Paint()
            ..color = Colors.orange
            ..strokeWidth = 1
            ..style = PaintingStyle.fill);

    lastX = lastX + widthBar + 5;
    if (childrenEnemy.length < 3)
      canvas.drawLine(
          Offset(lastX, yPosition),
          Offset(lastX + widthBar, yPosition),
          Paint()
            ..color = Colors.orange
            ..strokeWidth = 1
            ..style = PaintingStyle.fill);
  }

  void _showConversation() {
    Sounds.interaction();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: getString('talk_queen_boss_1'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL3IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_bossL3_queen_1'))],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.bossL3IdleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_player_L3_queen_boss'))],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_bossL3_queen_2'))],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.bossL3IdleRight(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onFinish: () {
        Sounds.interaction();
        // BossL3 no spawns enemies - removed addInitChild()
        // Habilitar ataques después de la conversación
        conversationFinished = true;
        Future.delayed(Duration(milliseconds: 500), () {
          gameRef.camera.moveToPlayerAnimated(zoom: 1);
        });
      },
      onChangeTalk: (index) {
        Sounds.interaction();
      },
      logicalKeyboardKeysToNext: [
        LogicalKeyboardKey.space,
      ],
    );
  }
}
