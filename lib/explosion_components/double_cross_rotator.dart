import 'dart:async';
import 'dart:math' as math;

import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class DoubleCrossRotator extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  DoubleCrossRotator({
    required super.position,
    required super.size,
    this.thickness = 10,
    this.rotationSpeed = 2,
  }) : super(anchor: Anchor.center);

  final double thickness;
  final double rotationSpeed;

  @override
  FutureOr<void> onLoad() {
    List<Color> colors = gameRef.gameColor.map((e) => e).toList();
    colors.shuffle();

    add(
      DoubleDoubleOneCrossRotator(
        position: Vector2(size.x * 0.25, size.y * 0.5),
        size: Vector2(size.x * 0.5, size.y),
        colors: colors,
        isReverse: true,
      ),
    );

    Color temp = colors[0];
    colors[0] = colors[2];
    colors[2] = temp;

    add(
      DoubleDoubleOneCrossRotator(
        position: Vector2(size.x * 0.75, size.y * 0.5),
        size: Vector2(size.x * 0.5, size.y),
        colors: colors,
        isReverse: false,
      ),
    );

    return super.onLoad();
  }
}

class DoubleDoubleOneCrossRotator extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final List<Color> colors;
  final bool isReverse;

  DoubleDoubleOneCrossRotator({
    required super.position,
    required super.size,
    required this.colors,
    required this.isReverse,
    this.thickness = 10,
    this.rotationSpeed = 2,
  })  : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  final double thickness;
  final double rotationSpeed;

  @override
  FutureOr<void> onLoad() {
    for (int i = 0; i < colors.length; i++) {
      Vector2 p;
      Vector2 s;

      if (i == 0) {
        p = Vector2(0, (size.y * 0.5) - 10);
        s = Vector2(size.x * 0.5, 20);
      } else if (i == 1) {
        p = Vector2((size.x * 0.5) - 10, 0);
        s = Vector2(20, size.y * 0.5);
      } else if (i == 2) {
        p = Vector2(size.x * 0.5, (size.y * 0.5) - 10);
        s = Vector2(size.x * 0.5, 20);
      } else {
        p = Vector2((size.x * 0.5) - 10, size.y * 0.5);
        s = Vector2(20, size.y * 0.5);
      }

      add(
        DoubleOneCrossLine(
          color: colors[i],
          p: p,
          s: s,
          isReverse: isReverse,
        ),
      );
    }

    add(
      isReverse
          ? RotateEffect.to(
              math.pi * 2,
              InfiniteEffectController(
                SpeedEffectController(
                  ReverseLinearEffectController(
                    5,
                  ),
                  speed: rotationSpeed,
                ),
              ),
            )
          : RotateEffect.to(
              math.pi * 2,
              InfiniteEffectController(
                EffectController(
                  speed: rotationSpeed,
                ),
              ),
            ),
    );

    return super.onLoad();
  }
}

class DoubleOneCrossLine extends PositionComponent
    with ParentIsA<DoubleDoubleOneCrossRotator> {
  final circlePaint = Paint();

  final Color color;
  final Vector2 p;
  final Vector2 s;
  final bool isReverse;

  DoubleOneCrossLine(
      {required this.color, required this.p, required this.s, required this.isReverse})
      : super(anchor: Anchor.center);

  @override
  void onMount() {
    if (isReverse) {
      add(
        RectangleHitbox(
          size: s,
          position: p,
          collisionType: CollisionType.passive,
        ),
      );
    }

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
