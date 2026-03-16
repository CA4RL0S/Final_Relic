import 'package:darkness_dungeon/constants/item_ids.dart';
import 'package:darkness_dungeon/util/player_inventory.dart';
import 'package:flutter/material.dart';

/// Panel de inventario reutilizable
///
/// Este panel muestra todos los items consumibles y mejoras permanentes
/// que el jugador ha adquirido.
class InventoryPanel {
  /// Muestra el panel de inventario como un diálogo
  static Future<void> show(
      BuildContext context, PlayerInventory inventory) async {
    // OPTIMIZADO: No recargar inventario cada vez que se abre
    // El inventario es Singleton y ya está en memoria actualizado
    // Solo se recarga al inicio de la app en main.dart
    
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _InventoryDialog(inventory: inventory),
    );
  }
}

class _InventoryDialog extends StatelessWidget {
  final PlayerInventory inventory;

  const _InventoryDialog({required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 300,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🎒 INVENTARIO',
                    style: TextStyle(
                      color: Colors.amber,
                      fontFamily: 'Normal',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              Divider(
                color: Colors.amber.withOpacity(0.3),
                thickness: 2,
                height: 10,
              ),

              // Contenido con scroll
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Sección de Consumibles
                      _buildSectionTitle('CONSUMIBLES'),

                      _buildInventoryItem(
                        '🛡️',
                        'Escudo Mágico',
                        inventory
                            .getConsumableQuantity(ItemIds.invincibilityShield),
                        Colors.cyan,
                      ),

                      _buildInventoryItem(
                        '🧪',
                        'Poción Pequeña',
                        inventory.getConsumableQuantity(ItemIds.potionSmall),
                        Colors.red,
                      ),

                      _buildInventoryItem(
                        '🧪',
                        'Poción Mediana',
                        inventory.getConsumableQuantity(ItemIds.potionMedium),
                        Colors.orange,
                      ),

                      _buildInventoryItem(
                        '🧪',
                        'Poción Grande',
                        inventory.getConsumableQuantity(ItemIds.potionLarge),
                        Colors.purple,
                      ),

                      _buildInventoryItem(
                        '🔑',
                        'Llaves',
                        inventory.getConsumableQuantity(ItemIds.keySingle) +
                            inventory.getConsumableQuantity(ItemIds.keyPack3) *
                                3,
                        Colors.yellow,
                      ),

                      const SizedBox(height: 15),

                      // Sección de Mejoras Permanentes
                      _buildSectionTitle('MEJORAS PERMANENTES'),

                      _buildUpgradeStatus(
                        '⚔️ Espada Mejorada',
                        inventory.hasPermanentUpgrade(ItemIds.weaponUpgrade1),
                      ),

                      _buildUpgradeStatus(
                        '⚔️ Espada Legendaria',
                        inventory.hasPermanentUpgrade(ItemIds.weaponUpgrade2),
                      ),

                      _buildUpgradeStatus(
                        '👟 Botas de Velocidad',
                        inventory.hasPermanentUpgrade(ItemIds.speedUpgrade1),
                      ),

                      _buildUpgradeStatus(
                        '💎 Amuleto de Stamina',
                        inventory.hasPermanentUpgrade(ItemIds.staminaUpgrade1),
                      ),

                      _buildUpgradeStatus(
                        '💎 Amuleto Supremo',
                        inventory.hasPermanentUpgrade(ItemIds.staminaUpgrade2),
                      ),

                      _buildUpgradeStatus(
                        '❤️ Corazón de Vida',
                        inventory.hasPermanentUpgrade(ItemIds.healthUpgrade1),
                      ),

                      _buildUpgradeStatus(
                        '❤️ Corazón Legendario',
                        inventory.hasPermanentUpgrade(ItemIds.healthUpgrade2),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Botón cerrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      fontFamily: 'Normal',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.amber,
          fontFamily: 'Normal',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildInventoryItem(
      String emoji, String name, int quantity, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: quantity > 0
              ? color.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                  color: quantity > 0 ? Colors.white : Colors.grey,
                  fontFamily: 'Normal',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: quantity > 0
                  ? color.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'x$quantity',
              style: TextStyle(
                color: quantity > 0 ? color : Colors.grey,
                fontFamily: 'Normal',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeStatus(String name, bool hasUpgrade) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasUpgrade
              ? Colors.green.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: hasUpgrade ? Colors.white : Colors.grey,
              fontFamily: 'Normal',
              fontSize: 11,
            ),
          ),
          Icon(
            hasUpgrade ? Icons.check_circle : Icons.cancel,
            color: hasUpgrade ? Colors.green : Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}
