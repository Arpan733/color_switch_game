import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player myPlayer;

  MyGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  @override
  Color backgroundColor() => Colors.black54;

  @override
  void onMount() {
    world.add(
      RectangleComponent(
        size: Vector2(100, 100),
        position: Vector2(-100, -100),
        paint: Paint()..color = Colors.black26,
      ),
    );
    world.add(
      RectangleComponent(
        size: Vector2(100, 100),
        position: Vector2(-100, -200),
        paint: Paint()..color = Colors.black26,
      ),
    );
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer = Player());

    super.onMount();
  }

  @override
  void update(double dt) {
    double cameraY = camera.viewfinder.position.y;
    double playerY = myPlayer.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(0, playerY);
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();

    super.onTapDown(event);
  }
}
