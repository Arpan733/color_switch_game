import 'dart:async';

import 'package:color_switch_game/explosion_components/double_cross_rotator.dart';
import 'package:color_switch_game/other_components/color_changer.dart';
import 'package:color_switch_game/other_components/ground.dart';
import 'package:color_switch_game/other_components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player myPlayer;
  final List<Color> gameColor;
  final Vector2 size;
  bool isGameOver = false;

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
  Future<void> onLoad() async {
    decorator = PaintDecorator.blur(0);
    FlameAudio.bgm.initialize();

    await Flame.images.loadAll(
      [
        'tap.png',
        'animated_star.gif',
      ],
    );

    await FlameAudio.audioCache.loadAll(
      [
        'background.mp3',
        'collect.wav',
        'explosion.wav',
      ],
    );

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
    world.add(Ground(position: Vector2(0, 470)));
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2(0, 0));
    FlameAudio.bgm.play('background.mp3');

    generateGameComponents();
  }

  generateGameComponents() {
    debugMode = true;
    world.add(
      ColorChanger(
        position: Vector2(0, 100),
      ),
    );
    world.add(
      DoubleCrossRotator(
        position: Vector2(0, -200),
        size: Vector2(300, 150),
      ),
    );
  }

  void onGameOver() {
    if (isGameOver) {
      FlameAudio.bgm.stop();
      pauseGameEngine();
      score.value = 0;

      if (world.children.isNotEmpty) {
        for (var element in world.children) {
          if (world.children.contains(element)) {
            try {
              element.removeFromParent();
            } catch (e) {
              print(e);
            }
          }
        }
      }

      resumeGameEngine();
      initializeGame();
    }
  }

  void pauseGameEngine() {
    (decorator as PaintDecorator).addBlur(5);
    timeScale = 0.0;
    FlameAudio.bgm.pause();
  }

  void resumeGameEngine() {
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
    FlameAudio.bgm.resume();
  }

  void increaseScore() {
    score.value++;
  }
}
