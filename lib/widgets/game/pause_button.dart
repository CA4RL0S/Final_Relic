import 'package:darkness_dungeon/util/dialogs.dart';
import 'package:flutter/material.dart';

/// Botón de pausa reutilizable para todos los niveles del juego
///
/// Este botón muestra el menú de pausa cuando se presiona.
class PauseButton extends StatelessWidget {
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const PauseButton({
    Key? key,
    this.onPause,
    this.onResume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPause?.call();
        Dialogs.showPauseMenu(
          context,
          onResume: () {
            onResume?.call();
          },
          onRestart: () {},
          onMainMenu: () {},
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Barra izquierda
            Container(
              width: 6,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            // Barra derecha
            Container(
              width: 6,
              height: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
