import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/experimental.dart';
import 'package:nextbigthing/components/platform.dart';
import 'package:nextbigthing/mario_lite.dart';
import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:nextbigthing/pages/gameover_page.dart';
import 'package:nextbigthing/pages/gameplay_page.dart';
import 'package:nextbigthing/pages/title_page.dart';
import 'package:nextbigthing/components/mario.dart' as mario;
import 'package:nextbigthing/constants/globals/globals.dart';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shake_gesture/shake_gesture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  mario.shaked = false;
  runApp(
    ShakeGesture(child: GameWidget(game: MarioLite()), onShake: () {
      mario.shaked = true;
      print("SHAKEEEEyyyyy");
    })
    );
}


class MarioLite extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late CameraComponent cameraComponent;

  @override
  Future<void> onLoad() async {

    cameraComponent = CameraComponent(world: world)
      ..viewport.size = Vector2(450, 50)
      ..viewport.position = Vector2(500, 0)
      ..viewfinder.visibleGameSize = Vector2(450, 50)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent]);

    final TiledComponent level = await TiledComponent.load(
      Globals.paths.tileMaps.level1,
      Vector2.all(Globals.numbers.tileSize),
    );

    add(level);

    ObjectGroup? actorsLayer = level.tileMap.getLayer<ObjectGroup>('Actors');

    if (actorsLayer == null) {
      throw Exception('Actors layer not found.');
    }

    for (final TiledObject obj in actorsLayer.objects) {
      switch (obj.name) {
        case 'Mario':
          
          add(mario.Mario(
            position: Vector2(
              obj.x,
              obj.y - 200,
            ),
            levelBounds: Rect.fromLTWH(
              0,
              0,
              level.tileMap.map.width.toDouble() * Globals.numbers.tileSize,
              level.tileMap.map.height.toDouble() * Globals.numbers.tileSize,
            )
          ));
          break;
        default:
          break;
      }
    }

    ObjectGroup? platformsLayer = level.tileMap.getLayer<ObjectGroup>('Platforms');

    if (platformsLayer == null) {
      throw Exception('Platforms layer not found.');
    }

    for (final TiledObject obj in platformsLayer.objects) {
      final Platform platform = Platform(
        position: Vector2(obj.x, obj.y),
        size: Vector2(obj.width, obj.height),
      );
      add(platform);
    }

    // add(LevelComponent());

    return super.onLoad();
  }

}

// class LevelComponent extends Component with HasGameRef<MarioLite> {
//
//   late Mario _mario;
//
//   // late Rectangle _levelBounds;
//
//   LevelComponent() : super();
//
//   @override
//   Future<void>? onLoad() async {
//     // Apply main level to canvas.
//     final TiledComponent level = await TiledComponent.load(
//       Globals.paths.tileMaps.level1,
//       Vector2.all(Globals.numbers.tileSize),
//     );
//
//     gameRef.add(level);
//
//     createPlatforms(level.tileMap);
//     createActors(level.tileMap);
//
//     // _levelBounds = Rectangle.fromPoints(
//     //   Vector2(
//     //     0,
//     //     0,
//     //   ),
//     //   Vector2(
//     //     level.tileMap.map.width.toDouble(),
//     //     level.tileMap.map.height.toDouble(),
//     //   ) *
//     //       Globals.numbers.tileSize,
//     // );
//
//     return super.onLoad();
//   }
//
//   // Create Platforms.
//   void createPlatforms(RenderableTiledMap tileMap) {
//     // Create platforms.
//     ObjectGroup? platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');
//
//     if (platformsLayer == null) {
//       throw Exception('Platforms layer not found.');
//     }
//
//     for (final TiledObject obj in platformsLayer.objects) {
//       final Platform platform = Platform(
//         position: Vector2(obj.x, obj.y),
//         size: Vector2(obj.width, obj.height),
//       );
//       gameRef.add(platform);
//     }
//   }
//
//   // Create Actors.
//   void createActors(RenderableTiledMap tileMap) {
//     // Create platforms.
//     ObjectGroup? actorsLayer = tileMap.getLayer<ObjectGroup>('Actors');
//
//     if (actorsLayer == null) {
//       throw Exception('Actors layer not found.');
//     }
//
//     for (final TiledObject obj in actorsLayer.objects) {
//       switch (obj.name) {
//         case 'Mario':
//           _mario = Mario(
//             position: Vector2(
//               obj.x,
//               obj.y - 50,
//             ),
//             // levelBounds: _levelBounds
//           );
//           gameRef.add(_mario);
//           break;
//         default:
//           break;
//       }
//     }
//   }
// }
