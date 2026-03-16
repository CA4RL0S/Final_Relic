import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/enemies/boss_l3.dart';
import 'package:darkness_dungeon/menu.dart';
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

/// NPC KidL3 (Princesa) para el Nivel 3
/// Aparece cuando el BossL3 muere y muestra la victoria final del juego
class KidL3 extends GameDecoration {
  bool conversationWithHero = false;

  KidL3(
    Vector2 position,
  ) : super.withAnimation(
          animation: NpcSpriteSheet.kidL3IdleLeft(),
          position: position,
          size: Vector2(valueByTileSize(16),
              valueByTileSize(22)), // Mismo tamaño que KidL2
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (!conversationWithHero && checkInterval('checkBossDead', 1000, dt)) {
      try {
        // Buscar si existe el BossL3 en el juego
        gameRef.enemies().firstWhere((e) => e is BossL3);
      } catch (e) {
        // Si no existe, significa que fue derrotado
        conversationWithHero = true;
        gameRef.camera.moveToTargetAnimated(
          target: this,
          onComplete: () {
            _startConversation();
          },
        );
      }
    }
  }

  void _startConversation() {
    Sounds.interaction();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: getString('talk_queen_1'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL3IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_player_L3_queen_1'))],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_queen_2'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL3IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_player_L3_queen_2'))],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [TextSpan(text: getString('talk_queen_3'))],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidL3IdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onFinish: () {
        Sounds.interaction();
        gameRef.camera.moveToPlayerAnimated(onComplete: () async {
          // Recompensa: Skin "Caballero Original"
          await PlayerInventory().addLevelReward(3);
          // Usar showCongratulations en vez de showVictoryDialog
          Dialogs.showCongratulations(gameRef.context);
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
