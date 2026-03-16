import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:darkness_dungeon/widgets/game/inventory_panel.dart';
import 'package:flutter/material.dart';

/// Botón de inventario reutilizable para todos los niveles del juego
///
/// Este botón muestra el panel de inventario cuando se presiona.
class InventoryButton extends StatefulWidget {
  const InventoryButton({Key? key}) : super(key: key);

  @override
  State<InventoryButton> createState() => _InventoryButtonState();
}

class _InventoryButtonState extends State<InventoryButton> {
  final PlayerInventory inventory = PlayerInventory();

  @override
  void initState() {
    super.initState();
    inventory.loadInventory();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        InventoryPanel.show(context, inventory);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.amber.withOpacity(0.8),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.inventory_2_outlined,
          color: Colors.amber,
          size: 24,
        ),
      ),
    );
  }
}
