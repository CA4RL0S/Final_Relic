import 'package:darkness_dungeon/screens/base_game_level.dart';
import 'package:flutter/material.dart';

/// Nivel 2 del juego - Segundo nivel con mayor dificultad
///
/// Este nivel usa un mapa diferente (level2.json) y no muestra
/// el banner de anuncios. Tiene una iluminación ligeramente más oscura.
class Level2 extends BaseGameLevel {
  const Level2({Key? key})
      : super(
          mapPath: 'tiled/level2.json',
          levelNumber: 2,
          showBanner: true, // ✅ Nivel 2 muestra banner
          key: key,
        );

  @override
  BaseGameLevelState<Level2> createState() => _Level2State();
}

class _Level2State extends BaseGameLevelState<Level2> {
  // Nivel 2 tiene iluminación más oscura para mayor dificultad
  // Sobrescribimos el color de iluminación
  Color getLightingColor() {
    return Colors.black.withOpacity(0.5);
  }
}
