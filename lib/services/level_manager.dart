import 'package:darkness_dungeon/screens/levels/level1.dart';
import 'package:darkness_dungeon/screens/levels/level2.dart';
import 'package:flutter/material.dart';

/// Gestor de niveles del juego
///
/// Este servicio centraliza la navegación entre niveles y
/// proporciona acceso a los diferentes niveles del juego.
class LevelManager {
  /// Obtiene el widget del nivel especificado
  ///
  /// [levelNumber] - Número del nivel (1, 2, etc.)
  /// Retorna el widget del nivel o Level1 si el número es inválido
  static Widget getLevel(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return const Level1();
      case 2:
        return const Level2();
      default:
        return const Level1();
    }
  }

  /// Navega al nivel especificado reemplazando la pantalla actual
  ///
  /// [context] - BuildContext para la navigación
  /// [levelNumber] - Número del nivel de destino
  static void goToLevel(BuildContext context, int levelNumber) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => getLevel(levelNumber)),
    );
  }

  /// Navega al nivel especificado sin reemplazar (push)
  ///
  /// [context] - BuildContext para la navegación
  /// [levelNumber] - Número del nivel de destino
  static void pushLevel(BuildContext context, int levelNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => getLevel(levelNumber)),
    );
  }

  /// Retorna al menú principal
  ///
  /// [context] - BuildContext para la navegación
  static void returnToMenu(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Número total de niveles en el juego
  static const int totalLevels = 2;

  /// Verifica si existe un nivel siguiente
  ///
  /// [currentLevel] - Número del nivel actual
  /// Retorna true si hay un nivel siguiente
  static bool hasNextLevel(int currentLevel) {
    return currentLevel < totalLevels;
  }

  /// Obtiene el número del siguiente nivel
  ///
  /// [currentLevel] - Número del nivel actual
  /// Retorna el número del siguiente nivel o null si no hay más niveles
  static int? getNextLevel(int currentLevel) {
    if (hasNextLevel(currentLevel)) {
      return currentLevel + 1;
    }
    return null;
  }
}
