import 'dart:async';
import 'dart:math' as math;

import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class SquareRotator extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  SquareRotator({
    required super.position,
    required super.size,
    this.thickness = 10,
    this.rotationSpeed = 2,
  })  : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  final double thickness;
  final double rotationSpeed;

  @override
  FutureOr<void> onLoad() {
    List<Color> colors = gameRef.gameColor.map((e) => e).toList();
    colors.shuffle();

    for (int i = 0; i < colors.length; i++) {
      Vector2 p;
      Vector2 s;

      if (i == 0) {
        p = Vector2(0, 0);
        s = Vector2(size.x, 20);
      } else if (i == 1) {
        p = Vector2(size.x - 20, 0);
        s = Vector2(20, size.y);
      } else if (i == 2) {
        p = Vector2(0, size.y - 20);
        s = Vector2(size.x, 20);
      } else {
        p = Vector2(0, 0);
        s = Vector2(20, size.y);
      }

      add(
        SquareLine(
          color: colors[i],
          p: p,
          s: s,
        ),
      );
    }

    add(RotateEffect.to(
      math.pi * 2,
      EffectController(
        infinite: true,
        speed: rotationSpeed,
      ),
    ));

    return super.onLoad();
  }
}

class SquareLine extends PositionComponent with ParentIsA<SquareRotator> {
  final circlePaint = Paint();

  final Color color;
  final Vector2 p;
  final Vector2 s;

  SquareLine({required this.color, required this.p, required this.s})
      : super(anchor: Anchor.center);

  @override
  void onMount() {
    add(
      RectangleHitbox(
        size: s,
        position: p,
      ),
    );

    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(p.x, p.y, s.x, s.y),
        const Radius.circular(15),
      ),
      circlePaint..color = color,
    );

    super.render(canvas);
  }
}
