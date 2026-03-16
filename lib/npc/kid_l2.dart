import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/boss_l2.dart';
import 'package:darkness_dungeon/screens/level_selection_screen.dart';
import 'package:darkness_dungeon/util/custom_sprite_animation_widget.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:darkness_dungeon/util/dialogs.dart';
import 'package:darkness_dungeon/util/functions.dart';
import 'package:darkness_dungeon/util/localization/strings_location.dart';
import 'package:darkness_dungeon/util/npc_sprite_sheet.dart';
import 'package:darkness_dungeon/util/player_sprite_sheet.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// NPC KidL2 para el Nivel 2
/// Interactúa con el jugador antes y después de derrotar al BossL2
class KidL2 extends GameDecoration with Sensor {
  bool _hasInteractedBeforeBoss = false;
  bool _conversationWithHero = false;

  KidL2(
    Vector2 position,
  ) : super.withAnimation(
          animation: NpcSpriteSheet.kidL2IdleLeft(),
          position: position,
          size: Vector2(
              valueByTileSize(16), valueByTileSize(22)), // Tamaño aumentado
        );

  @override
  void update(double dt) {
    super.update(dt);

    // Verificar si el boss ha sido derrotado
    if (!_conversationWithHero && checkInterval('checkBossDead', 1000, dt)) {
      try {
        gameRef.enemies().firstWhere((e) => e is BossL2);
      } catch (e) {
        // Boss derrotado - iniciar conversación de victoria
        _conversationWithHero = true;
        gameRef.camera.moveToTargetAnimated(
          target: this,
          onComplete: () {
            _startVictoryConversation();
          },
        );
      }
    }
  }

  @override
  void onContact(GameComponent component) {
    // Interacción cuando el jugador se acerca (antes de derrotar al boss)
    if (component is Player &&
        !_hasInteractedBeforeBoss &&
        !_conversationWithHero) {
      _hasInteractedBeforeBoss = true;
      _startInitialConversation();
    }
  }

  void _startInitialConversation() {
    Sounds.interaction();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: getString('talk_kidL2_1'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL2IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_player_L2_1'))],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_kidL2_2'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL2IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onChangeTalk: (index) {
        Sounds.interaction();
      },
      logicalKeyboardKeysToNext: [
        LogicalKeyboardKey.space,
      ],
    );
  }

  void _startVictoryConversation() {
    Sounds.interaction();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: getString('talk_kidL2_3'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL2IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_player_L2_2'))],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onFinish: () {
        Sounds.interaction();
        gameRef.camera.moveToPlayerAnimated(onComplete: () {
          Dialogs.showVictoryDialog(
            gameRef.context,
            () async {
              // Desbloquear Nivel 3
              await PlayerInventory().unlockNextLevel(2);
              // Recompensa: +50 vida máxima permanente
              await PlayerInventory().addLevelReward(2);

              Navigator.of(gameRef.context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const LevelSelectionScreen()),
                (Route<dynamic> route) => false,
              );
            },
          );
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
