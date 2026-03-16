/// Constantes del juego - Configuración global y valores de balanceo
///
/// Este archivo centraliza todas las constantes mágicas del juego para
/// facilitar el ajuste de balanceo y mantenimiento.

/// Constantes generales del juego
class GameConstants {
  // Tamaño base del tile (antes era variable global)
  static const double tileSize = 32.0;

  // Velocidades
  static const double playerBaseSpeed = tileSize * 2.5;
  static const double goblinSpeed = tileSize * 1.5;
  static const double impSpeed = tileSize * 2.0;
  static const double miniBossSpeed = tileSize * 1.2;
  static const double bossSpeed = tileSize * 1.0;

  // Radio de visión
  static const double playerVisionRadius = tileSize * 5;
  static const double enemyVisionRadius = tileSize * 4;

  // Zoom de cámara
  static const int maxVisibleTiles = 18;

  // Vida
  static const double playerBaseLife = 200.0;
  static const double goblinLife = 120.0;
  static const double impLife = 80.0;
  static const double miniBossLife = 200.0;
  static const double bossLife = 500.0;
}

/// Constantes de combate y stamina
class CombatConstants {
  // Costos de stamina
  static const double meleeAttackStaminaCost = 15.0;
  static const double rangeAttackStaminaCost = 10.0;

  // Regeneración de stamina
  static const double staminaRegenRate = 2.0;
  static const int staminaRegenIntervalMs = 50;

  // Stats base del jugador
  static const double playerBaseAttack = 25.0;
  static const double playerBaseStamina = 100.0;
  static const double playerRangeAttackDamage = 10.0;

  // Stats de enemigos
  static const double goblinAttack = 25.0;
  static const double impAttack = 20.0;
  static const double miniBossAttack = 40.0;
  static const double bossAttack = 60.0;

  // Intervalos de ataque (ms)
  static const int goblinAttackInterval = 800;
  static const int impAttackInterval = 1000;
  static const int miniBossAttackInterval = 800;
  static const int bossAttackInterval = 1200;
}

/// Constantes de intervalos de actualización (ms)
class UpdateConstants {
  // Intervalo de actualización de tiempo de invencibilidad
  static const int invincibilityUpdateIntervalMs = 500;

  // Intervalo de verificación de enemigos
  static const int enemyCheckIntervalMs = 200;

  // Intervalo de regeneración de stamina
  static const int staminaRegenIntervalMs = 50;
}

/// Constantes de audio
class AudioConstants {
  // Intervalo mínimo entre sonidos idénticos (ms) para evitar spam
  static const int minSoundIntervalMs = 80;

  // Volúmenes
  static const double attackPlayerVolume = 0.4;
  static const double attackRangeVolume = 0.3;
  static const double attackEnemyVolume = 0.4;
  static const double interactionVolume = 0.4;

  // Audio pools
  static const int minPlayersPerPool = 2;
  static const int maxPlayersAttack = 4;
  static const int maxPlayersExplosion = 5;
  static const int maxPlayersInteraction = 2;
}

/// Constantes de mejoras (upgrades)
class UpgradeConstants {
  // Mejoras de arma
  static const double weaponUpgrade1Bonus = 10.0;
  static const double weaponUpgrade2Bonus = 20.0;

  // Mejoras de stamina
  static const double staminaUpgrade1Bonus = 50.0;
  static const double staminaUpgrade2Bonus = 100.0;

  // Mejora de velocidad
  static const double speedUpgrade1Multiplier = 1.3;

  // Mejoras de vida
  static const double healthUpgrade1Bonus = 50.0;
  static const double healthUpgrade2Bonus = 100.0;
}

/// Constantes de pociones
class PotionConstants {
  static const double smallPotionHealing = 50.0;
  static const double mediumPotionHealing = 100.0;
  static const double largePotionHealing = 200.0;

  // Umbrales para usar pociones automáticamente
  static const double smallPotionThreshold = 50.0;
  static const double mediumPotionThreshold = 100.0;
}

/// Constantes de invencibilidad
class InvincibilityConstants {
  static const int shieldDurationSeconds = 30;
}
