# 🛠️ Guía de Desarrollo - Darkness Dungeon

Esta guía está diseñada para ayudar a los desarrolladores a modificar, extender y crear nuevo contenido para Darkness Dungeon.

## 📂 Estructura del Proyecto

Después de la refactorización, el proyecto sigue esta estructura:

- `lib/constants/`: Constantes globales (`GameConstants`, `ItemIds`). **¡Usa esto en lugar de números mágicos!**
- `lib/screens/levels/`: Niveles del juego (`Level1`, `Level2`).
- `lib/screens/base_game_level.dart`: Clase base para todos los niveles.
- `lib/player/`: Lógica del personaje principal (`Knight`).
- `lib/enemies/`: Clases de enemigos (`Goblin`, `Imp`, `Boss`).
- `lib/util/`: Utilidades, sonidos y spritesheets.

---

## ⚔️ Modificar el Jugador (Knight)

El jugador está definido en `lib/player/knight.dart`.

### Ajustar Estadísticas
Para cambiar velocidad, vida o daño, edita las constantes en `lib/constants/game_constants.dart`:

```dart
// En game_constants.dart
static const double playerSpeed = 120.0;
static const double playerLife = 100.0;
static const double playerAttack = 20.0;
```

### Cambiar Sprites
El jugador usa `PlayerSpriteSheet` en `lib/util/player_sprite_sheet.dart`.
Para cambiar la apariencia:
1. Reemplaza el archivo de imagen en `assets/images/player/`.
2. Ajusta el tamaño del sprite en `PlayerSpriteSheet` si es necesario.

---

## 👹 Modificar Enemigos Existentes

Los enemigos están en `lib/enemies/`. Tomemos como ejemplo al `Goblin`.

### Ajustar Comportamiento
Abre `lib/enemies/goblin.dart`. Puedes modificar:

- **Visión:** `radiusVision` en el método `update`.
- **Ataque:** `damage` y `interval` en `simpleAttackMelee`.
- **Movimiento:** `speed` en el constructor.

```dart
Goblin(Vector2 position)
    : super(
        // ...
        speed: GameConstants.tileSize * 1.5, // Velocidad
        life: 80, // Vida
      );
```

---

## 🆕 Crear un Nuevo Enemigo

Para crear un nuevo enemigo (ej. "Esqueleto"), sigue estos pasos:

1. **Crear el archivo:** Crea `lib/enemies/skeleton.dart`.
2. **Heredar de SimpleEnemy:**

```dart
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/constants/game_constants.dart';

class Skeleton extends SimpleEnemy with BlockMovementCollision {
  Skeleton(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(GameConstants.tileSize),
          speed: 80,
          life: 100,
          animation: SimpleDirectionAnimation(
            idleRight: _SpriteSheet.idleRight,
            runRight: _SpriteSheet.runRight,
            // ... define otras animaciones
          ),
        );

  @override
  void update(double dt) {
    // Lógica de persecución
    seeAndMoveToPlayer(
      closePlayer: (player) {
        // Lógica de ataque
        simpleAttackMelee(
          damage: 15,
          size: Vector2.all(GameConstants.tileSize),
        );
      },
      radiusVision: GameConstants.tileSize * 4,
    );
    super.update(dt);
  }
}
```

3. **Agregarlo al Nivel:**
   En el archivo del nivel (ej. `lib/screens/levels/level1.dart`) o en el mapa de Tiled, agrega el objeto y mapealo en `ObjectCollision`.

---

## 🗺️ Crear Nuevos Niveles

Gracias al sistema refactorizado, crear niveles es muy fácil.

1. **Diseñar Mapa:** Crea un archivo `.json` con Tiled (ej. `assets/images/tiled/level3.json`).
2. **Crear Clase de Nivel:** Crea `lib/screens/levels/level3.dart`.

```dart
import 'package:darkness_dungeon/screens/base_game_level.dart';

class Level3 extends BaseGameLevel {
  const Level3({Key? key})
      : super(
          mapPath: 'tiled/level3.json',
          levelNumber: 3,
          showBanner: true, // ¿Mostrar anuncios?
          key: key,
        );
}
```

3. **Registrar en LevelManager:** (Opcional, para navegación secuencial)
   Asegúrate de que la lógica de "Siguiente Nivel" en tu NPC o puerta apunte a `Level3`.

---

## 📦 Buenas Prácticas

1. **Usa GameLogger:** En lugar de `print()`, usa `GameLogger.info()`, `GameLogger.error()`, etc.
2. **Usa Constantes:** No escribas números sueltos (`32.0`). Usa `GameConstants.tileSize`.
3. **ValueNotifier:** Para estados de UI reactivos (como los anuncios), usa `ValueNotifier` en lugar de polling.
