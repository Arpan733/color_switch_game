import 'dart:async';

import 'package:color_switch_game/circle_rotator.dart';
import 'package:color_switch_game/color_changer.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  Player({
    required super.position,
    this.radius = 15,
  });

  Color color = Colors.white;

  final velocity = Vector2(0, 20);
  final gravity = 980.0;
  final jumpSpeed = -350.0;
  final double radius;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox(
      radius: radius,
      anchor: anchor,
      collisionType: CollisionType.active,
    ));

    return super.onLoad();
  }

  @override
  void onMount() {
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    super.onMount();
  }

  @override
  void update(double dt) {
    position += velocity * dt;

    Ground ground = gameRef.findByKey(ComponentKey.named(Ground.keyName))!;

    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      velocity.setValues(0, 0);
      position = Vector2(0, ground.position.y - (height / 2));
    } else {
      velocity.y += gravity * dt;
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      (size / 2).toOffset(),
      radius,
      Paint()..color = color,
    );

    super.render(canvas);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ColorChanger) {
      other.removeFromParent();
      changeColorToRandom();
    } else if (other is CircleArc) {
      if (color != other.color) {
        gameRef.onGameOver();
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }

  jump() {
    velocity.y = jumpSpeed;
  }

  changeColorToRandom() {
    color = gameRef.gameColor.random();
  }
}
