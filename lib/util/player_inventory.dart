import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:darkness_dungeon/util/logger.dart';

class PlayerInventory {
  static const String _coinsKey = 'player_coins';
  static const String _itemsKey = 'player_items';
  static const String _upgradesKey = 'player_upgrades';
  static const String _levelKey = 'player_max_level';
  static const String _skinsKey = 'player_skins';
  static const String _activeSkinKey = 'player_active_skin';
  static const String _levelRewardsKey = 'player_level_rewards';
  static const String _tutorialKey = 'tutorial_completed';

  // OPTIMIZADO: Debouncing para escrituras en nube
  static const Duration _cloudSaveDebounceTime = Duration(seconds: 3);
  Timer? _cloudSaveTimer;
  bool _hasUnsavedChanges = false;

  // Singleton
  static final PlayerInventory _instance = PlayerInventory._internal();
  factory PlayerInventory() => _instance;
  PlayerInventory._internal();

  int _coins = 0;
  int _maxLevelReached = 1;
  Map<String, int> _consumableItems = {}; // itemId -> cantidad
  List<String> _permanentUpgrades = []; // upgrades permanentes compradas
  List<String> _unlockedSkins = ['default']; // Skins desbloqueadas
  String _activeSkin = 'default'; // Skin equipada
  List<int> _claimedLevelRewards =
      []; // Niveles cuyas recompensas ya se reclamaron
  bool _tutorialCompleted = false;

  int get coins => _coins;
  int get maxLevelReached => _maxLevelReached;
  Map<String, int> get consumableItems => Map.unmodifiable(_consumableItems);
  List<String> get permanentUpgrades => List.unmodifiable(_permanentUpgrades);
  List<String> get unlockedSkins => List.unmodifiable(_unlockedSkins);
  String get activeSkin => _activeSkin;
  List<int> get claimedLevelRewards => List.unmodifiable(_claimedLevelRewards);
  bool get needsTutorial => !_tutorialCompleted;
  bool get tutorialCompleted => _tutorialCompleted;

  // Cargar datos guardados (Local + Nube)
  Future<void> loadInventory() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Cargar localmente primero (para rapidez)
    _coins = prefs.getInt(_coinsKey) ?? 0;
    _maxLevelReached = prefs.getInt(_levelKey) ?? 1;

    final itemsString = prefs.getStringList(_itemsKey) ?? [];
    _consumableItems.clear();
    for (String item in itemsString) {
      final parts = item.split(':');
      if (parts.length == 2) {
        _consumableItems[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }
    _permanentUpgrades = prefs.getStringList(_upgradesKey) ?? [];
    _unlockedSkins = prefs.getStringList(_skinsKey) ?? ['default'];
    _activeSkin = prefs.getString(_activeSkinKey) ?? 'default';
    final rewardsStrings = prefs.getStringList(_levelRewardsKey) ?? [];
    _claimedLevelRewards =
        rewardsStrings.map((s) => int.tryParse(s) ?? 0).toList();
    _tutorialCompleted = prefs.getBool(_tutorialKey) ?? false;

    // 2. Intentar sincronizar con la nube si hay usuario logueado
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          final cloudLevel = data['maxLevel'] as int? ?? 1;
          final cloudCoins = data['coins'] as int? ?? 0;

          // Lógica de conflicto simple: Si la nube tiene mayor progreso, usar nube.
          // O si es igual, usar el que tenga más monedas (opcional, aquí priorizamos nivel)
          if (cloudLevel > _maxLevelReached) {
            _maxLevelReached = cloudLevel;
            _coins = cloudCoins; // Asumimos que las monedas van con el nivel

            // Cargar items de nube
            if (data['items'] != null) {
              _consumableItems = Map<String, int>.from(data['items']);
            }
            // Cargar upgrades de nube
            if (data['upgrades'] != null) {
              _permanentUpgrades = List<String>.from(data['upgrades']);
            }
            // Cargar tutorial completado de nube
            if (data['tutorialCompleted'] == true) {
              _tutorialCompleted = true;
            }

            // Actualizar local con lo nuevo de la nube
            await saveInventory(onlyLocal: true);
            GameLogger.info('Datos sincronizados desde la nube');
          } else {
            // Si local es más avanzado, actualizar nube
            if (_maxLevelReached > cloudLevel) {
              await saveInventory();
            }
          }
        }
      } catch (e) {
        GameLogger.error('Error cargando de nube: $e');
      }
    }
  }

  // OPTIMIZADO: Guardar datos con debouncing para la nube
  Future<void> saveInventory(
      {bool onlyLocal = false, bool immediate = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, _coins);
    await prefs.setInt(_levelKey, _maxLevelReached);

    final itemsString =
        _consumableItems.entries.map((e) => '${e.key}:${e.value}').toList();
    await prefs.setStringList(_itemsKey, itemsString);
    await prefs.setStringList(_upgradesKey, _permanentUpgrades);
    await prefs.setStringList(_skinsKey, _unlockedSkins);
    await prefs.setString(_activeSkinKey, _activeSkin);
    await prefs.setStringList(_levelRewardsKey,
        _claimedLevelRewards.map((i) => i.toString()).toList());
    await prefs.setBool(_tutorialKey, _tutorialCompleted);

    if (onlyLocal) return;

    // OPTIMIZADO: Usar debouncing para la nube
    if (immediate) {
      // Guardar inmediatamente (para momentos críticos)
      _cloudSaveTimer?.cancel();
      await _saveToCloud();
    } else {
      // Debouncing: esperar 3 segundos antes de guardar
      _hasUnsavedChanges = true;
      _cloudSaveTimer?.cancel();
      _cloudSaveTimer = Timer(_cloudSaveDebounceTime, () async {
        if (_hasUnsavedChanges) {
          await _saveToCloud();
          _hasUnsavedChanges = false;
        }
      });
    }
  }

  // Método privado para guardar en la nube
  Future<void> _saveToCloud() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'coins': _coins,
          'maxLevel': _maxLevelReached,
          'items': _consumableItems,
          'upgrades': _permanentUpgrades,
          'skins': _unlockedSkins,
          'activeSkin': _activeSkin,
          'levelRewards': _claimedLevelRewards,
          'tutorialCompleted': _tutorialCompleted,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        GameLogger.info('Datos guardados en la nube');
      } catch (e) {
        GameLogger.error('Error guardando en nube: $e');
      }
    }
  }

  // NUEVO: Forzar guardado inmediato antes de cerrar la app
  Future<void> forceSave() async {
    _cloudSaveTimer?.cancel();
    await saveInventory(immediate: true);
  }

  // Agregar monedas
  Future<void> addCoins(int amount) async {
    _coins += amount;
    await saveInventory();
  }

  // Gastar monedas
  Future<bool> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      await saveInventory();
      return true;
    }
    return false;
  }

  // Agregar item consumible
  Future<void> addConsumableItem(String itemId, int quantity) async {
    _consumableItems[itemId] = (_consumableItems[itemId] ?? 0) + quantity;
    await saveInventory();
  }

  // Usar item consumible
  Future<bool> useConsumableItem(String itemId) async {
    final quantity = _consumableItems[itemId] ?? 0;
    if (quantity > 0) {
      _consumableItems[itemId] = quantity - 1;
      if (_consumableItems[itemId] == 0) {
        _consumableItems.remove(itemId);
      }
      await saveInventory();
      return true;
    }
    return false;
  }

  // Obtener cantidad de un item consumible
  int getConsumableQuantity(String itemId) {
    return _consumableItems[itemId] ?? 0;
  }

  // Agregar upgrade permanente
  Future<void> addPermanentUpgrade(String upgradeId) async {
    if (!_permanentUpgrades.contains(upgradeId)) {
      _permanentUpgrades.add(upgradeId);
      await saveInventory(immediate: true); // OPTIMIZADO: Compras son críticas
    }
  }

  // Verificar si tiene un upgrade permanente
  bool hasPermanentUpgrade(String upgradeId) {
    return _permanentUpgrades.contains(upgradeId);
  }

  // Resetear inventario (para testing)
  Future<void> resetInventory() async {
    _coins = 0;
    _maxLevelReached = 1;
    _consumableItems.clear();
    _permanentUpgrades.clear();
    _unlockedSkins = ['default'];
    _activeSkin = 'default';
    _claimedLevelRewards.clear();
    _tutorialCompleted = false;
    await saveInventory(immediate: true);
  }

  // Desbloquear siguiente nivel
  Future<void> unlockNextLevel(int currentLevel) async {
    if (currentLevel >= _maxLevelReached) {
      _maxLevelReached = currentLevel + 1;
      await saveInventory(immediate: true);
    }
  }

  // ============ SISTEMA DE RECOMPENSAS POR NIVEL ============

  /// Otorgar recompensa al completar un nivel
  /// Nivel 1: +15 ataque permanente
  /// Nivel 2: +50 vida máxima permanente
  /// Nivel 3: Skin "Caballero Original"
  Future<void> addLevelReward(int level) async {
    if (_claimedLevelRewards.contains(level)) return; // Ya reclamada
    _claimedLevelRewards.add(level);

    switch (level) {
      case 1:
        await addPermanentUpgrade('level_reward_attack');
        break;
      case 2:
        await addPermanentUpgrade('level_reward_health');
        break;
      case 3:
        await unlockSkin('knight');
        break;
    }
    await saveInventory(immediate: true);
  }

  /// Verificar si ya reclamó la recompensa de un nivel
  bool hasClaimedLevelReward(int level) {
    return _claimedLevelRewards.contains(level);
  }

  // ============ SISTEMA DE SKINS ============

  /// Desbloquear una skin
  Future<void> unlockSkin(String skinId) async {
    if (!_unlockedSkins.contains(skinId)) {
      _unlockedSkins.add(skinId);
      await saveInventory(immediate: true);
    }
  }

  /// Equipar una skin (debe estar desbloqueada)
  Future<bool> setActiveSkin(String skinId) async {
    if (_unlockedSkins.contains(skinId)) {
      _activeSkin = skinId;
      await saveInventory(immediate: true);
      return true;
    }
    return false;
  }

  /// Obtener la skin equipada actualmente
  String getActiveSkin() => _activeSkin;

  /// Verificar si una skin está desbloqueada
  bool hasSkin(String skinId) => _unlockedSkins.contains(skinId);

  // ============ SISTEMA DE TUTORIAL ============

  /// Marcar el tutorial como completado
  Future<void> markTutorialCompleted() async {
    _tutorialCompleted = true;
    await saveInventory(immediate: true);
  }

  // NUEVO: Limpiar recursos al cerrar
  void dispose() {
    _cloudSaveTimer?.cancel();
  }
}
