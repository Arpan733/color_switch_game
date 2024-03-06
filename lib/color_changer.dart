import 'dart:async';
import 'dart:math' as math;

import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColorChanger extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final colorPaint = Paint();

  ColorChanger({
    required super.position,
    this.radius = 20,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
        );

  final double radius;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox(
      radius: radius,
      anchor: anchor,
      position: size / 2,
      collisionType: CollisionType.passive,
    ));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    double circle = math.pi * 2;
    final sweep = circle / gameRef.gameColor.length;

    for (int i = 0; i < gameRef.gameColor.length; i++) {
      canvas.drawArc(
        size.toRect(),
        i * sweep,
        sweep,
        true,
        colorPaint..color = gameRef.gameColor[i],
      );
    }

    super.render(canvas);
  }
}
