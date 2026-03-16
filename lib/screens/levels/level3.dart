import 'package:darkness_dungeon/screens/base_game_level.dart';
import 'package:flutter/material.dart';

/// Nivel 3 del juego - Tercer nivel con mayor dificultad
///
/// Este nivel usa un mapa diferente (level3.json) y muestra
/// el banner de anuncios. Tiene una iluminación similar al Nivel 2.
class Level3 extends BaseGameLevel {
  const Level3({Key? key})
      : super(
          mapPath: 'tiled/level3.json', // Converted from embedded to external tilesets
          levelNumber: 3,
          showBanner: true, // Nivel 3 muestra banner
          key: key,
        );

  @override
  BaseGameLevelState<Level3> createState() => _Level3State();
}

class _Level3State extends BaseGameLevelState<Level3> {
  // Nivel 3 tiene iluminación similar al Nivel 2
  Color getLightingColor() {
    return Colors.black.withOpacity(0.5);
  }
}
