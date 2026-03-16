class ShopItem {
  final String id;
  final String name;
  final String description;
  final int priceInCoins;
  final double priceInMoney; // Precio en pesos mexicanos (MXN)
  final String imagePath;
  final ShopItemType type;
  final int? quantity; // Para items consumibles
  final dynamic effectValue; // Valor del efecto (ej: +10 ataque, +50 vida)
  
  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInCoins,
    required this.priceInMoney,
    required this.imagePath,
    required this.type,
    this.quantity,
    this.effectValue,
  });
}

enum ShopItemType {
  coinsPack,      // Paquetes de monedas (compra con dinero real)
  potion,         // Pociones de vida (consumible)
  weaponUpgrade,  // Mejoras de arma (permanente)
  speedUpgrade,   // Mejoras de velocidad (permanente)
  staminaUpgrade, // Mejoras de stamina (permanente)
  healthUpgrade,  // Mejoras de vida máxima (permanente)
  key,            // Llaves (consumible)
  bomb,           // Bombas (consumible)
  specialPack,    // Packs especiales (compra con dinero real)
  invincibility,  // Invencibilidad temporal (consumible)
}

