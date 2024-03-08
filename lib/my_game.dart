import 'dart:async';

import 'package:color_switch_game/explosion_components/circle_rotator.dart';
import 'package:color_switch_game/explosion_components/double_cross_rotator.dart';
import 'package:color_switch_game/explosion_components/one_cross_rotator.dart';
import 'package:color_switch_game/explosion_components/square_rotator.dart';
import 'package:color_switch_game/other_components/color_changer.dart';
import 'package:color_switch_game/other_components/ground.dart';
import 'package:color_switch_game/other_components/player.dart';
import 'package:color_switch_game/other_components/start_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
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

  List<dynamic> _gameComponents = [];

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
        'star.png',
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
    world.add(Ground(position: Vector2(0, 420)));
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2(0, 0));
    FlameAudio.bgm.play('background.mp3');

    generateGameComponents(
      p: Vector2(0, 0),
    );
  }

  generateGameComponents({required Vector2 p}) {
    List<String> names = [
      'single circle',
      'square',
      'one cross',
      'double cross',
    ];

    for (int i = 0; i < 10; i++) {
      names.shuffle();
      generateFromPosition(
        p: p + Vector2(0, i * -400),
        name: names.first,
      );
    }
  }

  generateFromPosition({required Vector2 p, required String name}) {
    ColorChanger cc = colorChanger(
      p: p,
    );

    _gameComponents.add(
      cc,
    );
    world.add(
      cc,
    );

    p = p + Vector2(0, -200);

    StarComponent st = star(
      p: p,
    );

    _gameComponents.add(
      st,
    );
    world.add(
      st,
    );

    var cmp = takeComponents(
      p: p,
      name: name,
    );

    _gameComponents.add(
      cmp,
    );
    world.add(
      cmp,
    );
  }

  ColorChanger colorChanger({required Vector2 p}) {
    return ColorChanger(
      position: p,
    );
  }

  StarComponent star({required Vector2 p}) {
    return StarComponent(
      position: p,
    );
  }

  dynamic takeComponents({required Vector2 p, required String name}) {
    Map<String, dynamic> components = {
      'single circle': CircleRotator(
        position: p,
        size: Vector2(200, 200),
      ),
      'square': SquareRotator(
        position: p,
        size: Vector2(200, 200),
      ),
      'one cross': OneCrossRotator(
        position: p,
        size: Vector2(200, 200),
      ),
      'double cross': DoubleCrossRotator(
        position: p,
        size: Vector2(300, 150),
      ),
    };

    return components[name];
  }

  void checkToGenerateNextBatch({required StarComponent starComponent}) {
    final allStarComponents = _gameComponents.whereType<StarComponent>().toList();
    final length = allStarComponents.length;

    for (int i = 0; i < allStarComponents.length; i++) {
      if (starComponent.key == allStarComponents[i].key && i >= length - 2) {
        final lastStar = allStarComponents.last;
        generateGameComponents(p: lastStar.position - Vector2(0, 200));
        _tryToGarbageCollect(starComponent: starComponent);
      }
    }
  }

  void _tryToGarbageCollect({required StarComponent starComponent}) {
    for (int i = 0; i < _gameComponents.length; i++) {
      if (starComponent == _gameComponents[i] && i >= 15) {
        _removeComponentsFromGame(n: i - 7);
        break;
      }
    }
  }

  void _removeComponentsFromGame({required int n}) {
    for (int i = n - 1; i >= 0; i--) {
      _gameComponents[i].removeFromParent();
      _gameComponents.removeAt(i);
    }
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
              debugPrint(e.toString());
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
