import 'package:darkness_dungeon/constants/game_constants.dart';

const TILE_SIZE_SPRITE_SHEET = 16;

double valueByTileSize(double value) {
  return value * (GameConstants.tileSize / TILE_SIZE_SPRITE_SHEET);
}
