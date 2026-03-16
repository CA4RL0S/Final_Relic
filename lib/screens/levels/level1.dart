import 'package:darkness_dungeon/screens/base_game_level.dart';
import 'package:flutter/material.dart';

/// Nivel 1 del juego - Primer nivel principal
///
/// Este es el primer nivel del juego. Muestra el banner de anuncios
/// en la parte inferior.
class Level1 extends BaseGameLevel {
  const Level1({Key? key})
      : super(
          mapPath: 'tiled/map.json',
          levelNumber: 1,
          showBanner: true, // Nivel 1 muestra banner
          key: key,
        );

  @override
  BaseGameLevelState<Level1> createState() => _Level1State();
}

class _Level1State extends BaseGameLevelState<Level1> {
  // Nivel 1 usa configuración por defecto de BaseGameLevel
  // Si necesitaras personalización, podrías sobrescribir métodos aquí

  // Por ejemplo, si quisieras un color de iluminación diferente:
  // @override
  // Color _getLightingColor() {
  //   return Colors.black.withOpacity(0.5);
  // }
}
