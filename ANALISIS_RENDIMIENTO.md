# 📊 Análisis de Rendimiento - Final Relic

## 🎯 Resumen Ejecutivo

Este documento detalla los problemas potenciales de rendimiento encontrados en el código del juego, clasificados por severidad y área.

---

## 🔴 PROBLEMAS CRÍTICOS (Alta Prioridad)

### 1. **Menu.dart - Timer de cambio de sprites cada 2 segundos**
**Ubicación:** `lib/menu.dart:392`
```dart
_timer = async.Timer.periodic(Duration(seconds: 2), (timer) {
  setState(() {
    currentPosition++;
    if (currentPosition > sprites.length - 1) {
      currentPosition = 0;
    }
  });
});
```
**Problema:** 
- Llama a `setState()` cada 2 segundos, provocando un rebuild completo del widget
- Esto es innecesario porque solo cambia un sprite

**Impacto:** Rebuilds frecuentes de toda la pantalla del menú

**Solución:**
- Usar `AnimatedBuilder` o `ValueNotifier` para actualizar solo el widget del sprite
- Considerar usar `StatefulWidget` solo para el sprite animado

---

### 2. **ShopScreen - AnimationController continuo para monedas**
**Ubicación:** `lib/shop/shop_screen.dart:23-26`
```dart
_coinAnimationController = AnimationController(
  duration: Duration(seconds: 2),
  vsync: this,
)..repeat();
```
**Problema:**
- Animación que se ejecuta infinitamente incluso cuando no es visible
- Provoca rebuilds constantes del widget de monedas

**Impacto:** Alto consumo de CPU innecesario

**Solución:**
- Pausar la animación cuando la pantalla no está visible
- Usar `AnimationController.stop()` en `dispose()`

---

### 3. **PlayerInventory - Llamadas excesivas a Firebase**
**Ubicación:** `lib/util/player_inventory.dart:90-119`
```dart
Future<void> saveInventory({bool onlyLocal = false}) async {
  // ... código local ...
  
  if (onlyLocal) return;
  
  // Guardar en nube si hay usuario
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      // ...
    }, SetOptions(merge: true));
  }
}
```
**Problema:**
- Se guarda en Firebase cada vez que se modifica el inventario
- No hay debouncing ni batching de escrituras
- Llamadas frecuentes durante el juego (usar pociones, recoger items, etc.)

**Impacto:** 
- Alto consumo de red y batería
- Latencia en operaciones del inventario
- Costos innecesarios de Firebase

**Solución:**
- Implementar debouncing (esperar X segundos antes de guardar)
- Guardar en nube solo en momentos clave (completar nivel, cerrar app)
- Usar batching para múltiples cambios

---

### 4. **InventoryPanel - Reload completo en cada apertura**
**Ubicación:** `lib/widgets/game/inventory_panel.dart:13`
```dart
static Future<void> show(
    BuildContext context, PlayerInventory inventory) async {
  // Recargar inventario para asegurar datos actualizados
  await inventory.loadInventory();
```
**Problema:**
- Lee de SharedPreferences Y potencialmente Firebase cada vez que se abre el inventario
- Operación síncrona que bloquea la UI

**Impacto:** Lag notable al abrir el inventario

**Solución:**
- Mantener el inventario en memoria y solo recargar cuando sea necesario
- Usar un sistema de eventos/notificaciones para actualizar la UI

---

## 🟡 PROBLEMAS MODERADOS (Media Prioridad)

### 5. **Knight.dart - Actualización de posición del escudo en cada frame**
**Ubicación:** `lib/player/knight.dart:407-409`
```dart
if (isInvincible && _shieldEffect != null && _shieldEffect!.isMounted) {
  _shieldEffect!.position = center;
```
**Problema:**
- Actualiza la posición en cada frame (60 fps)
- Innecesario si el jugador no se mueve mucho

**Impacto:** Cálculos redundantes

**Solución:**
- El escudo podría ser un `FollowerComponent` que sigue automáticamente al jugador
- O usar `checkInterval` para actualizaciones menos frecuentes

---

### 6. **KnightInterface - Cálculos de UI complejos en cada frame**
**Ubicación:** `lib/interface/knight_interface.dart:38-177`
```dart
void _drawShieldIndicator(Canvas canvas) {
  // Múltiples cálculos y dibujado de formas complejas
  // RRect, Circles, gradients, shadows, etc.
```
**Problema:**
- Dibuja múltiples formas complejas con sombras y gradientes en cada frame
- Cálculos repetidos que no cambian frecuentemente

**Impacto:** Sobrecarga del renderizado

**Solución:**
- Pre-renderizar elementos estáticos en sprites o cachés
- Usar `Canvas.saveLayer` con cuidado
- Simplificar gradientes y sombras

---

### 7. **MiniBoss - LightingConfig en proyectiles**
**Ubicación:** `lib/enemies/mini_boss.dart:91-95`
```dart
lightingConfig: LightingConfig(
  radius: GameConstants.tileSize * 0.9,
  blurBorder: GameConstants.tileSize / 2,
  color: Colors.deepOrangeAccent.withOpacity(0.4),
),
```
**Problema:**
- Cada proyectil del MiniBoss tiene iluminación dinámica
- Múltiples proyectiles = múltiples cálculos de luz

**Impacto:** Caída de FPS cuando hay muchos proyectiles

**Solución:**
- Desactivar iluminación en proyectiles (ya está desactivado en Knight pero no en MiniBoss)
- O reducir drásticamente el radio

---

### 8. **Boss.dart - childrenEnemy.forEach en onDie**
**Ubicación:** `lib/enemies/boss.dart:103-105`
```dart
childrenEnemy.forEach((e) {
  if (!e.isDead) e.onDie();
});
```
**Problema:**
- Si el boss tiene muchos hijos, esto puede causar múltiples animaciones simultáneas
- No hay control del número máximo de enemigos

**Impacto:** Pico de lag al morir el boss

**Solución:**
- Limitar el número de hijos o escalonar sus muertes
- Usar animaciones más simples

---

## 🟢 OPTIMIZACIONES MENORES (Baja Prioridad)

### 9. **Menu.dart - Lista de Futures para sprites**
**Ubicación:** `lib/menu.dart:29-35`
```dart
List<Future<SpriteAnimation>> sprites = [
  PlayerSpriteSheet.idleRight(),
  EnemySpriteSheet.goblinIdleRight(),
  // ...
];
```
**Problema:**
- Los sprites se cargan como Futures pero no se espera su carga
- Podría causar frame drops iniciales

**Impacto:** Menor, pero puede causar stuttering inicial

**Solución:**
- Cargar todos los sprites en `initState()` con await
- Mostrar indicador de carga

---

### 10. **ShopScreen - TweenAnimationBuilder para cada item**
**Ubicación:** `lib/shop/shop_screen.dart:337-348`
```dart
return TweenAnimationBuilder<double>(
  duration: Duration(milliseconds: 400 + (index * 100)),
  tween: Tween(begin: 0.0, end: 1.0),
  builder: (context, value, child) {
    return Transform.scale(
      scale: value,
      child: Opacity(
        opacity: value,
        child: child,
      ),
    );
  },
```
**Problema:**
- Cada item del GridView tiene su propia animación
- Con muchos items visibles, múltiples animaciones simultáneas

**Impacto:** Menor, solo en la primera carga de la tienda

**Solución:**
- Reducir duración o eliminar después de la primera carga
- Usar `AnimatedList` en lugar de GridView

---

### 11. **Sounds.dart - Verificación de tiempo en cada llamada**
**Ubicación:** `lib/util/sounds.dart:64-76`
```dart
static bool _canPlay(DateTime lastTime) {
  return DateTime.now().difference(lastTime).inMilliseconds > _minInterval;
}
```
**Problema:**
- `DateTime.now()` se llama frecuentemente
- Cálculo de diferencia en cada intento de reproducir sonido

**Impacto:** Muy menor, pero podría optimizarse

**Solución:**
- Usar un sistema de cooldown más eficiente
- O simplemente confiar en el AudioPool para manejar el solapamiento

---

### 12. **BaseGameLevel - Multiple Sprite.load() en Joystick**
**Ubicación:** `lib/screens/base_game_level.dart:186-221`
```dart
directional: JoystickDirectional(
  spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
  spriteKnobDirectional: Sprite.load('joystick_knob.png'),
```
**Problema:**
- Los sprites del joystick se cargan cada vez que se crea un nivel
- No hay caché de estos recursos

**Impacto:** Ligero delay al iniciar niveles

**Solución:**
- Pre-cargar y cachear sprites del joystick
- Usar Flame's sprite cache

---

## ✅ BUENAS PRÁCTICAS ENCONTRADAS

### Optimizaciones ya implementadas:

1. ✅ **AudioPools pre-cargados** - Excelente uso de pools para baja latencia
2. ✅ **checkInterval en Knight.update()** - Reduce frecuencia de verificaciones costosas
3. ✅ **Iluminación desactivada en proyectiles del jugador** - Buen balance visual/rendimiento
4. ✅ **Lighting reducido en antorchas** (sin pulseVariation)
5. ✅ **Singleton en PlayerInventory** - Evita múltiples instancias
6. ✅ **Dispose correcto de timers y animaciones**

---

## 📈 RECOMENDACIONES GENERALES

### Prioridad Alta:
1. Implementar debouncing para Firebase writes
2. Optimizar rebuilds en Menu.dart con ValueNotifier
3. Cachear datos del inventario en memoria
4. Pausar animaciones cuando no son visibles

### Prioridad Media:
5. Reducir cálculos de UI complejos
6. Limitar efectos visuales simultáneos
7. Optimizar lighting en enemigos

### Prioridad Baja:
8. Pre-cargar assets del joystick
9. Optimizar animaciones de la tienda
10. Simplificar verificaciones de sonido

---

## 🔧 HERRAMIENTAS DE MEDICIÓN RECOMENDADAS

Para validar las optimizaciones:
- Flutter DevTools Performance Overlay
- `flutter run --profile` para profiling real
- `flutter run --trace-skia` para análisis de rendering
- Firebase Performance Monitoring

---

## 📝 NOTAS ADICIONALES

- El juego ya tiene varias optimizaciones implementadas (ver sección de buenas prácticas)
- Los problemas encontrados son típicos de juegos 2D con Flame
- La mayoría son fáciles de solucionar sin cambiar la arquitectura
- Priorizar optimizaciones que afecten gameplay vs menús

---

**Fecha del análisis:** 21 de Noviembre, 2025
**Versión del código:** main branch
**Analizador:** AI Assistant

