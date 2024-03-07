import 'dart:async';

import 'package:color_switch_game/explosion_components/circle_rotator.dart';
import 'package:color_switch_game/explosion_components/double_cross_rotator.dart';
import 'package:color_switch_game/explosion_components/one_cross_rotator.dart';
import 'package:color_switch_game/explosion_components/square_rotator.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:color_switch_game/other_components/color_changer.dart';
import 'package:color_switch_game/other_components/ground.dart';
import 'package:color_switch_game/other_components/start_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final playerPaint = Paint();
  int c = 0;
  double oldY = 0.0;

  Player({
    required super.position,
    this.radius = 15,
  });

  Color color = Colors.white;

  final velocity = Vector2(0, 20);
  final gravity = 980.0;
  final jumpSpeed = -350.0;
  final double radius;

  late Ground ground;

  @override
  FutureOr<void> onLoad() {
    add(
      CircleHitbox(
        radius: radius,
        anchor: anchor,
        collisionType: CollisionType.active,
      ),
    );

    return super.onLoad();
  }

  @override
  void onMount() {
    ground = gameRef.findByKey(ComponentKey.named(Ground.keyName))!;

    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    super.onMount();
  }

  @override
  void update(double dt) {
    position += velocity * dt;

    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y && c == 0) {
      velocity.setValues(0, 0);
      position = Vector2(0, ground.position.y - (height / 2));
    } else {
      velocity.y += gravity * dt;
    }

    if (position.y > 0) {
      if (position.y < oldY + 500 && position.y > 500) {
        gameRef.isGameOver = true;
        gameRef.onGameOver();
        gameRef.isGameOver = false;
      }
    } else {
      if (position.y > oldY + 500 && position.y < 0) {
        gameRef.isGameOver = true;
        gameRef.onGameOver();
        gameRef.isGameOver = false;
      }
    }

    if (position.y <= oldY || (position.y < 500 && position.y > 0)) {
      oldY = position.y;
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      (size / 2).toOffset(),
      radius,
      playerPaint..color = color,
    );

    super.render(canvas);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ColorChanger) {
      other.removeFromParent();
      changeColorToRandom();
    } else if (other is CircleArc && !gameRef.isGameOver) {
      gameRef.isGameOver = true;
      if (color != other.color) {
        gameRef.onGameOver();
        FlameAudio.play('explosion.wav');
      }
      gameRef.isGameOver = false;
    } else if (other is SquareLine && !gameRef.isGameOver) {
      gameRef.isGameOver = true;
      if (color != other.color) {
        gameRef.onGameOver();
        FlameAudio.play('explosion.wav');
      }
      gameRef.isGameOver = false;
    } else if (other is OneCrossLine && !gameRef.isGameOver) {
      gameRef.isGameOver = true;
      if (color != other.color) {
        gameRef.onGameOver();
        FlameAudio.play('explosion.wav');
      }
      gameRef.isGameOver = false;
    } else if (other is DoubleOneCrossLine && !gameRef.isGameOver) {
      gameRef.isGameOver = true;
      if (color != other.color) {
        gameRef.onGameOver();
        FlameAudio.play('explosion.wav');
      }
      gameRef.isGameOver = false;
    } else if (other is StarComponent) {
      other.showCollectEffect();
      gameRef.increaseScore();
      FlameAudio.play('collect.wav');
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }

  jump() {
    velocity.y = jumpSpeed;

    if (c == 0) {
      ground.removeFromParent();
    }

    c++;
  }

  changeColorToRandom() {
    color = gameRef.gameColor.random();
  }
}
