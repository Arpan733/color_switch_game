import 'dart:async';

import 'package:color_switch_game/circle_rotator.dart';
import 'package:color_switch_game/color_changer.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:color_switch_game/start_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player myPlayer;
  final List<Color> gameColor;
  final Vector2 size;

  final ValueNotifier<int> score = ValueNotifier(0);

  bool get isPause => timeScale == 0.0;

  MyGame({
    required this.size,
    this.gameColor = const [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
    ],
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: size.x,
            height: size.y,
          ),
        );

  @override
  Color backgroundColor() => Colors.black54;

  @override
  FutureOr<void> onLoad() {
    decorator = PaintDecorator.blur(0);

    return super.onLoad();
  }

  @override
  void onMount() {
    initializeGame();

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

  initializeGame() {
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2(0, 0));

    generateGameComponents();
  }

  generateGameComponents() {
    world.add(
      ColorChanger(
        position: Vector2(0, 100),
      ),
    );
    world.add(
      CircleRotator(
        position: Vector2(0, -100),
        size: Vector2(200, 200),
      ),
    );
    world.add(
      StarComponent(
        position: Vector2(0, -100),
      ),
    );
    world.add(
      ColorChanger(
        position: Vector2(0, -300),
      ),
    );
    world.add(
      CircleRotator(
        position: Vector2(0, -500),
        size: Vector2(200, 200),
      ),
    );
  }

  void onGameOver() {
    for (var element in world.children) {
      element.removeFromParent();
    }

    initializeGame();
  }

  void pauseGameEngine() {
    (decorator as PaintDecorator).addBlur(5);
    timeScale = 0.0;
  }

  void resumeGameEngine() {
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
  }

  void increaseScore() {
    score.value++;
  }
}
