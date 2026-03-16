import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/screens/base_game_level.dart';
import 'package:darkness_dungeon/screens/levels/level1.dart';
import 'package:darkness_dungeon/util/dialogs.dart';
import 'package:darkness_dungeon/services/ad_service.dart';
import 'package:darkness_dungeon/util/logger.dart';
import 'package:flutter/material.dart';

class GameController extends GameComponent {
  bool showGameOver = false;
  static int deathCount = 0; // Contador de muertes para anuncios

  @override
  void update(double dt) {
    if (checkInterval('gameOver', 100, dt)) {
      if (gameRef.player != null && gameRef.player?.isDead == true) {
        if (!showGameOver) {
          showGameOver = true;
          _showDialogGameOver();
        }
      }
    }
    super.update(dt);
  }

  void _showDialogGameOver() {
    showGameOver = true;

    // Incrementar contador de muertes
    deathCount++;
    GameLogger.game('Muerte #$deathCount');

    // Mostrar anuncio intersticial cada 3 muertes
    if (deathCount % 3 == 0) {
      GameLogger.ads('Mostrando anuncio intersticial (cada 3 muertes)');
      AdService().showInterstitialAd();
    }

    Dialogs.showGameOver(
      context,
      () {
        GameLogger.game('Reiniciando desde Game Over...');

        // Marcar que estamos reiniciando ANTES de cerrar
        BaseGameLevelState.isRestarting = true;

        // Cerrar el diálogo primero
        Navigator.of(context).pop();

        // Esperar más tiempo para que dispose() se complete ANTES de crear el nuevo juego
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            GameLogger.game('Navegando a nuevo juego...');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Level1()),
              (Route<dynamic> route) => false,
            );
          }
        });
      },
    );
  }
}
