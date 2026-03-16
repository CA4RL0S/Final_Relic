import 'shop_item.dart';

class ShopData {
  static List<ShopItem> getShopItems() {
    return [
      // ========== PAQUETES DE MONEDAS (Compra con dinero real - MXN) ==========
      ShopItem(
        id: 'coins_100',
        name: '💰 100 Monedas',
        description: 'Paquete pequeño de monedas',
        priceInCoins: 0,
        priceInMoney: 20.0, // 20 pesos mexicanos
        imagePath: 'items/coin_bag_small.png',
        type: ShopItemType.coinsPack,
        quantity: 100,
      ),
      ShopItem(
        id: 'coins_500',
        name: '💰 500 Monedas',
        description: 'Paquete mediano de monedas (20% descuento)',
        priceInCoins: 0,
        priceInMoney: 80.0, // 80 MXN (ahorro de 20 MXN)
        imagePath: 'items/coin_bag_medium.png',
        type: ShopItemType.coinsPack,
        quantity: 500,
      ),
      ShopItem(
        id: 'coins_1000',
        name: '💰 1000 Monedas',
        description: 'Paquete grande de monedas (30% descuento)',
        priceInCoins: 0,
        priceInMoney: 140.0, // 140 MXN (ahorro de 60 MXN)
        imagePath: 'items/coin_bag_large.png',
        type: ShopItemType.coinsPack,
        quantity: 1000,
      ),
      ShopItem(
        id: 'coins_2500',
        name: '💰 2500 Monedas',
        description: 'Paquete premium de monedas (40% descuento)',
        priceInCoins: 0,
        priceInMoney: 300.0, // 300 MXN (ahorro de 200 MXN)
        imagePath: 'items/treasure_chest_gold.png',
        type: ShopItemType.coinsPack,
        quantity: 2500,
      ),
      
      // ========== CONSUMIBLES - POCIONES ==========
      ShopItem(
        id: 'potion_small',
        name: '🧪 Poción Pequeña',
        description: 'Restaura 50 de vida',
        priceInCoins: 20,
        priceInMoney: 0,
        imagePath: 'items/potion_red.png',
        type: ShopItemType.potion,
        effectValue: 50,
      ),
      ShopItem(
        id: 'potion_medium',
        name: '🧪 Poción Mediana',
        description: 'Restaura 100 de vida',
        priceInCoins: 40,
        priceInMoney: 0,
        imagePath: 'items/potion_red.png',
        type: ShopItemType.potion,
        effectValue: 100,
      ),
      ShopItem(
        id: 'potion_large',
        name: '🧪 Poción Grande',
        description: 'Restaura 200 de vida',
        priceInCoins: 70,
        priceInMoney: 0,
        imagePath: 'items/potion_red.png',
        type: ShopItemType.potion,
        effectValue: 200,
      ),
      
      // ========== MEJORAS DE ARMA (Permanentes) ==========
      ShopItem(
        id: 'weapon_upgrade_1',
        name: '⚔️ Espada Mejorada',
        description: 'Aumenta el ataque en +10',
        priceInCoins: 150,
        priceInMoney: 0,
        imagePath: 'items/sword_upgrade.png',
        type: ShopItemType.weaponUpgrade,
        effectValue: 10,
      ),
      ShopItem(
        id: 'weapon_upgrade_2',
        name: '⚔️ Espada Legendaria',
        description: 'Aumenta el ataque en +20',
        priceInCoins: 300,
        priceInMoney: 0,
        imagePath: 'items/sword_upgrade.png',
        type: ShopItemType.weaponUpgrade,
        effectValue: 20,
      ),
      
      // ========== MEJORAS DE VELOCIDAD (Permanentes) ==========
      ShopItem(
        id: 'speed_upgrade_1',
        name: '👟 Botas de Velocidad',
        description: 'Aumenta la velocidad en +30%',
        priceInCoins: 200,
        priceInMoney: 0,
        imagePath: 'items/speed_boots.png',
        type: ShopItemType.speedUpgrade,
        effectValue: 0.3,
      ),
      
      // ========== MEJORAS DE STAMINA (Permanentes) ==========
      ShopItem(
        id: 'stamina_upgrade_1',
        name: '💎 Amuleto de Stamina',
        description: 'Aumenta stamina máxima en +50',
        priceInCoins: 180,
        priceInMoney: 0,
        imagePath: 'items/stamina_crystal.png',
        type: ShopItemType.staminaUpgrade,
        effectValue: 50,
      ),
      ShopItem(
        id: 'stamina_upgrade_2',
        name: '💎 Amuleto Supremo',
        description: 'Aumenta stamina máxima en +100',
        priceInCoins: 350,
        priceInMoney: 0,
        imagePath: 'items/stamina_crystal.png',
        type: ShopItemType.staminaUpgrade,
        effectValue: 100,
      ),
      
      // ========== MEJORAS DE VIDA MÁXIMA (Permanentes) ==========
      ShopItem(
        id: 'health_upgrade_1',
        name: '❤️ Corazón de Vida',
        description: 'Aumenta vida máxima en +50',
        priceInCoins: 200,
        priceInMoney: 0,
        imagePath: 'items/potion_red.png',
        type: ShopItemType.healthUpgrade,
        effectValue: 50,
      ),
      ShopItem(
        id: 'health_upgrade_2',
        name: '❤️ Corazón Legendario',
        description: 'Aumenta vida máxima en +100',
        priceInCoins: 400,
        priceInMoney: 0,
        imagePath: 'items/potion_red.png',
        type: ShopItemType.healthUpgrade,
        effectValue: 100,
      ),
      
      // ========== CONSUMIBLES - LLAVES ==========
      ShopItem(
        id: 'key_single',
        name: '🔑 Llave de Plata',
        description: 'Abre puertas cerradas',
        priceInCoins: 50,
        priceInMoney: 0,
        imagePath: 'items/key_silver.png',
        type: ShopItemType.key,
        quantity: 1,
      ),
      ShopItem(
        id: 'key_pack_3',
        name: '🔑 Pack de 3 Llaves',
        description: '3 llaves (20% descuento)',
        priceInCoins: 120,
        priceInMoney: 0,
        imagePath: 'items/key_silver.png',
        type: ShopItemType.key,
        quantity: 3,
      ),
      
      // ========== CONSUMIBLES - INVENCIBILIDAD ==========
      ShopItem(
        id: 'invincibility_30s',
        name: '🛡️ Escudo Mágico',
        description: '30 segundos de invencibilidad',
        priceInCoins: 100,
        priceInMoney: 0,
        imagePath: 'items/magic_shield.png',
        type: ShopItemType.invincibility,
        effectValue: 30,
      ),
      
      // ========== PACKS ESPECIALES (Compra con dinero real - MXN) ==========
      ShopItem(
        id: 'pack_starter',
        name: '📦 Pack Iniciante',
        description: '200 monedas + 3 pociones + 1 llave',
        priceInCoins: 0,
        priceInMoney: 40.0, // 40 MXN
        imagePath: 'items/gift_chest.png',
        type: ShopItemType.specialPack,
      ),
      ShopItem(
        id: 'pack_warrior',
        name: '📦 Pack Guerrero',
        description: '500 monedas + Espada Mejorada + 5 pociones',
        priceInCoins: 0,
        priceInMoney: 100.0, // 100 MXN
        imagePath: 'items/gift_chest.png',
        type: ShopItemType.specialPack,
      ),
      ShopItem(
        id: 'pack_legendary',
        name: '📦 Pack Legendario',
        description: '1500 monedas + Todas las mejoras + 10 pociones',
        priceInCoins: 0,
        priceInMoney: 200.0, // 200 MXN
        imagePath: 'items/gift_chest.png',
        type: ShopItemType.specialPack,
      ),
    ];
  }
  
  // Obtener solo items que se compran con monedas
  static List<ShopItem> getCoinShopItems() {
    return getShopItems()
        .where((item) => item.priceInCoins > 0)
        .toList();
  }
  
  // Obtener solo items que se compran con dinero real
  static List<ShopItem> getRealMoneyItems() {
    return getShopItems()
        .where((item) => item.priceInMoney > 0)
        .toList();
  }
  
  // Buscar item por ID
  static ShopItem? getItemById(String id) {
    try {
      return getShopItems().firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

