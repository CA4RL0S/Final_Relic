import 'package:darkness_dungeon/util/player_inventory.dart';

/// Helpers para testing y debug del sistema de tienda
class DebugHelpers {
  static final PlayerInventory _inventory = PlayerInventory();
  
  /// Agregar monedas para testing
  static Future<void> addTestCoins(int amount) async {
    await _inventory.loadInventory();
    await _inventory.addCoins(amount);
    print('✅ Agregadas $amount monedas. Total: ${_inventory.coins}');
  }
  
  /// Resetear todo el inventario
  static Future<void> resetInventory() async {
    await _inventory.resetInventory();
    print('🔄 Inventario reseteado');
  }
  
  /// Agregar todas las mejoras permanentes (para testing)
  static Future<void> unlockAllUpgrades() async {
    await _inventory.loadInventory();
    
    final upgrades = [
      'weapon_upgrade_1',
      'weapon_upgrade_2',
      'speed_upgrade_1',
      'stamina_upgrade_1',
      'stamina_upgrade_2',
      'health_upgrade_1',
      'health_upgrade_2',
    ];
    
    for (var upgrade in upgrades) {
      await _inventory.addPermanentUpgrade(upgrade);
    }
    
    print('🎁 Todas las mejoras desbloqueadas');
  }
  
  /// Agregar items consumibles de prueba
  static Future<void> addTestConsumables() async {
    await _inventory.loadInventory();
    
    await _inventory.addConsumableItem('potion_small', 5);
    await _inventory.addConsumableItem('potion_medium', 3);
    await _inventory.addConsumableItem('potion_large', 1);
    await _inventory.addConsumableItem('key_single', 3);
    
    print('🧪 Items consumibles agregados');
  }
  
  /// Mostrar estado actual del inventario
  static Future<void> printInventoryStatus() async {
    await _inventory.loadInventory();
    
    print('\n📦 ESTADO DEL INVENTARIO:');
    print('💰 Monedas: ${_inventory.coins}');
    print('🎯 Mejoras permanentes: ${_inventory.permanentUpgrades.length}');
    print('   ${_inventory.permanentUpgrades.join(", ")}');
    print('🧪 Items consumibles:');
    _inventory.consumableItems.forEach((key, value) {
      print('   - $key: x$value');
    });
    print('');
  }
  
  /// Dar el pack completo de inicio (para testing)
  static Future<void> giveStarterPack() async {
    await _inventory.loadInventory();
    await _inventory.addCoins(1000);
    await _inventory.addConsumableItem('potion_medium', 5);
    await _inventory.addConsumableItem('key_single', 3);
    print('🎁 Pack de inicio otorgado: 1000 monedas, 5 pociones, 3 llaves');
  }
}

