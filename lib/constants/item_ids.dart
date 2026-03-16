/// IDs de items del juego
///
/// Este archivo centraliza todos los IDs de items como constantes
/// en lugar de usar strings hardcodeados en todo el código.
/// Esto previene typos y facilita el mantenimiento.

class ItemIds {
  // ==================== CONSUMIBLES ====================

  /// Pociones de vida
  static const String potionSmall = 'potion_small';
  static const String potionMedium = 'potion_medium';
  static const String potionLarge = 'potion_large';

  /// Llaves
  static const String keySingle = 'key_single';
  static const String keyPack3 = 'key_pack_3';

  /// Items especiales
  static const String invincibilityShield = 'invincibility_30s';

  // ==================== UPGRADES PERMANENTES ====================

  /// Mejoras de arma
  static const String weaponUpgrade1 = 'weapon_upgrade_1';
  static const String weaponUpgrade2 = 'weapon_upgrade_2';

  /// Mejoras de velocidad
  static const String speedUpgrade1 = 'speed_upgrade_1';

  /// Mejoras de stamina
  static const String staminaUpgrade1 = 'stamina_upgrade_1';
  static const String staminaUpgrade2 = 'stamina_upgrade_2';

  /// Mejoras de vida máxima
  static const String healthUpgrade1 = 'health_upgrade_1';
  static const String healthUpgrade2 = 'health_upgrade_2';
}
