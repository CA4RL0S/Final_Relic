import 'dart:convert';
import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/constants/game_constants.dart';
import 'package:darkness_dungeon/decoration/door.dart';
import 'package:darkness_dungeon/decoration/key.dart';
import 'package:darkness_dungeon/decoration/potion_life.dart';
import 'package:darkness_dungeon/decoration/spikes.dart';
import 'package:darkness_dungeon/decoration/torch.dart';
import 'package:darkness_dungeon/enemies/boss.dart';
import 'package:darkness_dungeon/enemies/goblin.dart';
import 'package:darkness_dungeon/enemies/imp.dart';
import 'package:darkness_dungeon/enemies/mini_boss.dart';
import 'package:darkness_dungeon/enemies/medium_l2.dart';
import 'package:darkness_dungeon/enemies/mini_l2.dart';
import 'package:darkness_dungeon/enemies/boss_l2.dart';
import 'package:darkness_dungeon/enemies/mini_l3.dart';
import 'package:darkness_dungeon/enemies/medium_l3.dart';
import 'package:darkness_dungeon/enemies/boss_l3.dart';
import 'package:darkness_dungeon/interface/knight_interface.dart';
import 'package:darkness_dungeon/npc/kid.dart';
import 'package:darkness_dungeon/npc/kid_l2.dart';
import 'package:darkness_dungeon/npc/kid_l3.dart';
import 'package:darkness_dungeon/npc/wizard_npc.dart';
import 'package:darkness_dungeon/player/knight.dart';
import 'package:darkness_dungeon/util/sounds.dart';
import 'package:darkness_dungeon/util/logger.dart';
import 'package:darkness_dungeon/widgets/game_controller.dart';
import 'package:darkness_dungeon/widgets/game/pause_button.dart';
import 'package:darkness_dungeon/widgets/game/inventory_button.dart';
import 'package:darkness_dungeon/services/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Clase base abstracta para todos los niveles del juego
///
/// Esta clase centraliza toda la lógica común entre niveles,
/// eliminando la duplicación de código entre game.dart y level2.dart.
///
/// Cada nivel solo necesita especificar:
/// - mapPath: ruta al archivo .json del mapa Tiled
/// - showBanner: si debe mostrar banner de anuncios
/// - levelNumber: número del nivel (para identificación)
abstract class BaseGameLevel extends StatefulWidget {
  final String mapPath;
  final bool showBanner;
  final int levelNumber;

  const BaseGameLevel({
    required this.mapPath,
    required this.levelNumber,
    this.showBanner = false,
    Key? key,
  }) : super(key: key);
}

/// Estado base para todos los niveles
abstract class BaseGameLevelState<T extends BaseGameLevel> extends State<T> {
  BonfireGameInterface? gameRef;
  final AdService _adService = AdService();

  // Flag estático para evitar detener música al reiniciar
  static bool isRestarting = false;

  // Configuración del joystick (puede ser sobrescrito por subclases)
  bool get useJoystick => true;

  Vector2? _customPlayerPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Sounds.playBackgroundSound();
    GameLogger.game('Iniciando nivel ${widget.levelNumber}...');
    _loadMapAndFindPlayer();

    // Solo cargar banner si este nivel lo requiere
    if (widget.showBanner) {
      GameLogger.ads('Cargando banner ad para nivel ${widget.levelNumber}...');
      _adService.loadBannerAd();
      Future.delayed(const Duration(seconds: 1), _checkBannerStatus);
    }
  }

  Future<void> _loadMapAndFindPlayer() async {
    try {
      GameLogger.info('Intentando cargar mapa: ${widget.mapPath}');
      GameLogger.info('Ruta completa: assets/images/${widget.mapPath}');

      final manifestContent = await DefaultAssetBundle.of(context)
          .loadString('assets/images/${widget.mapPath}');

      GameLogger.success('Mapa cargado exitosamente: ${widget.mapPath}');
      final mapData = jsonDecode(manifestContent);

      // Buscar en todas las capas de objetos
      if (mapData['layers'] != null) {
        // Calcular factor de escala basado en el tamaño de tiles del mapa vs el juego
        double mapTileWidth = (mapData['tilewidth'] as num?)?.toDouble() ??
            GameConstants.tileSize;
        double mapTileHeight = (mapData['tileheight'] as num?)?.toDouble() ??
            GameConstants.tileSize;

        double scaleX = GameConstants.tileSize / mapTileWidth;
        double scaleY = GameConstants.tileSize / mapTileHeight;

        for (var layer in mapData['layers']) {
          if (layer['type'] == 'objectgroup' && layer['objects'] != null) {
            for (var object in layer['objects']) {
              if (object['name'] == 'player') {
                // Aplicar el factor de escala a las coordenadas
                double x = (object['x'] as num).toDouble() * scaleX;
                double y = (object['y'] as num).toDouble() * scaleY;

                setState(() {
                  _customPlayerPosition = Vector2(x, y);
                });
                GameLogger.game(
                    'Found player in map at $_customPlayerPosition (Scaled from map pos: ${(object['x'] as num)}, ${(object['y'] as num)} with scale: $scaleX, $scaleY)');
                return;
              }
            }
          }
        }
      }
      GameLogger.warning('No se encontró posición del jugador en el mapa');
    } catch (e) {
      GameLogger.error('Error parsing map for player position', e);
      GameLogger.error('Mapa que falló: ${widget.mapPath}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _checkBannerStatus() {
    if (mounted && widget.showBanner) {
      if (_adService.isBannerLoaded) {
        GameLogger.success('Banner cargado para nivel ${widget.levelNumber}');
        setState(() {});
      } else {
        Future.delayed(const Duration(seconds: 1), _checkBannerStatus);
      }
    }
  }

  @override
  void dispose() {
    GameLogger.cleanup('Limpiando nivel ${widget.levelNumber}...');

    // Limpiar banner si se estaba usando, PERO NO si estamos reiniciando
    // (porque el nuevo nivel ya habrá cargado o estará cargando uno nuevo)
    if (widget.showBanner && !isRestarting) {
      _adService.disposeBannerAd();
    }

    // Limpiar sonidos
    // Sounds.stopBackgroundSound(); // No detener música al salir del nivel para mantenerla en menús

    if (isRestarting) {
      GameLogger.info('Reiniciando nivel...');
      isRestarting = false;
    }

    // Detener y limpiar el juego si existe
    if (gameRef != null) {
      try {
        gameRef!.pauseEngine();
        gameRef!.overlays.clear();

        if (gameRef is BonfireGame) {
          final bonfireGame = gameRef as BonfireGame;
          for (var component in bonfireGame.children) {
            try {
              component.removeFromParent();
            } catch (e) {
              // Ignorar errores al remover componentes
            }
          }
        }
        gameRef = null;
      } catch (e) {
        GameLogger.error('Error al limpiar el juego', e);
      }
    }

    GameLogger.success('Nivel ${widget.levelNumber} limpiado');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Juego principal con banner opcional
          if (widget.showBanner)
            Column(
              children: [
                Expanded(child: _buildGame(context)),
                _buildBanner(),
              ],
            )
          else
            _buildGame(context),

          // Botones de UI siempre encima
          _buildUIButtons(context),
        ],
      ),
    );
  }

  /// Construye el widget del juego Bonfire
  Widget _buildGame(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return BonfireWidget(
      onReady: (game) {
        gameRef = game;
      },
      playerControllers: [
        _buildPlayerController(),
      ],
      player: Knight(
        _customPlayerPosition ??
            Vector2(2 * GameConstants.tileSize, 3 * GameConstants.tileSize),
      ),
      map: WorldMapByTiled(
        WorldMapReader.fromAsset(widget.mapPath),
        forceTileSize: Vector2(GameConstants.tileSize, GameConstants.tileSize),
        objectsBuilder: _buildObjectsBuilder(),
      ),
      components: [GameController()],
      interface: KnightInterface(),
      lightingColorGame: _getLightingColor(),
      backgroundColor: Colors.grey[900]!,
      cameraConfig: CameraConfig(
        speed: 3,
        zoom: getZoomFromMaxVisibleTile(
          context,
          GameConstants.tileSize,
          GameConstants.maxVisibleTiles,
        ),
      ),
    );
  }

  /// Construye el controlador del jugador (joystick o teclado)
  PlayerController _buildPlayerController() {
    if (useJoystick) {
      return Joystick(
        directional: JoystickDirectional(
          spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
          spriteKnobDirectional: Sprite.load('joystick_knob.png'),
          size: 100,
          isFixed: false,
        ),
        actions: [
          JoystickAction(
            actionId: 0,
            sprite: Sprite.load('joystick_atack.png'),
            spritePressed: Sprite.load('joystick_atack_selected.png'),
            size: 80,
            margin: const EdgeInsets.only(bottom: 50, right: 50),
          ),
          JoystickAction(
            actionId: 1,
            sprite: Sprite.load('joystick_atack_range.png'),
            spritePressed: Sprite.load('joystick_atack_range_selected.png'),
            size: 50,
            margin: const EdgeInsets.only(bottom: 50, right: 160),
          ),
          JoystickAction(
            actionId: 2,
            sprite: Sprite.load('joystick_shield.png'),
            spritePressed: Sprite.load('joystick_atack_selected.png'),
            size: 50,
            margin: const EdgeInsets.only(bottom: 130, right: 140),
          ),
          JoystickAction(
            actionId: 3,
            sprite: Sprite.load('joystick_health.png'),
            spritePressed: Sprite.load('joystick_atack_range_selected.png'),
            size: 50,
            margin: const EdgeInsets.only(bottom: 160, right: 60),
          ),
        ],
      );
    } else {
      return Keyboard(
        config: KeyboardConfig(
          directionalKeys: [KeyboardDirectionalKeys.arrows()],
          acceptedKeys: [
            LogicalKeyboardKey.space,
            LogicalKeyboardKey.keyZ,
            LogicalKeyboardKey.keyX,
            LogicalKeyboardKey.keyC,
          ],
        ),
      );
    }
  }

  /// Construye el mapa de objetos del nivel
  /// Puede ser sobrescrito por subclases si necesitan objetos personalizados
  Map<String, GameComponent Function(TiledObjectProperties)>
      _buildObjectsBuilder() {
    return {
      'door': (p) => Door(p.position, p.size),
      'doorL3': (p) => Door(p.position, p.size),
      'torch': (p) => Torch(p.position),
      'potion': (p) => PotionLife(p.position, 30),
      'wizard': (p) => WizardNPC(p.position),
      'spikes': (p) => Spikes(p.position),
      'key': (p) => DoorKey(p.position),
      'kid': (p) => Kid(p.position),
      'kidL2': (p) => KidL2(p.position),
      'kidL3': (p) => KidL3(p.position),
      'boss': (p) => Boss(p.position),
      'bossL3': (p) => BossL3(p.position),
      'goblin': (p) => Goblin(p.position),
      'meduimL3': (p) => MediumL3(p.position), // Nombre en Tiled (con typo)
      'imp': (p) => Imp(p.position),
      'miniL3': (p) => MiniL3(p.position),
      'miniL2': (p) => MiniL2(p.position),
      'mediumL2': (p) => MediumL2(p.position),
      'bossL2': (p) => BossL2(p.position),
      'mini_boss': (p) => MiniBoss(p.position),
      'torch_empty': (p) => Torch(p.position, empty: true),
    };
  }

  /// Color de iluminación del nivel
  /// Puede ser sobrescrito por subclases para niveles más oscuros
  Color _getLightingColor() {
    return Colors.black.withOpacity(0.4);
  }

  /// Construye los botones de UI (pausa e inventario)
  Widget _buildUIButtons(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: PauseButton(
              onPause: () {
                gameRef?.pauseEngine();
                // Asegurar que el overlay de pausa no bloquee inputs si usamos overlays de Bonfire
                // Pero aquí usamos un Dialog de Flutter, así que está bien.
              },
              onResume: () {
                gameRef?.resumeEngine();
              },
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: InventoryButton(),
          ),
        ],
      ),
    );
  }

  /// Construye el widget del banner de anuncios
  Widget _buildBanner() {
    if (_adService.isBannerLoaded && _adService.bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _adService.bannerAd!.size.width.toDouble(),
        height: _adService.bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _adService.bannerAd!),
      );
    } else {
      // Indicador mientras carga
      return Container(
        height: 50,
        color: Colors.grey[800],
        child: const Center(
          child: Text(
            'Cargando anuncio...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'Normal',
            ),
          ),
        ),
      );
    }
  }
}
