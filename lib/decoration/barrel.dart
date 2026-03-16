import 'package:bonfire/bonfire.dart';
import 'package:darkness_dungeon/constants/game_constants.dart';

class Barrel extends GameDecoration {
  Barrel(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('items/barrel.png'),
          position: position,
          size: Vector2(GameConstants.tileSize, GameConstants.tileSize),
        );

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(GameConstants.tileSize * 0.6, GameConstants.tileSize * 0.6),
        position: Vector2(GameConstants.tileSize * 0.2, 0),
      ),
    );
    return super.onLoad();
  }
}
