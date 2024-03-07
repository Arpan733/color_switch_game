import 'dart:async';
import 'dart:math' as math;

import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class CircleRotator extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  CircleRotator({
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
    List<Color> color = gameRef.gameColor.map((e) => e).toList();
    color.shuffle();
    double circle = math.pi * 2;
    final sweep = circle / color.length;

    for (int i = 0; i < color.length; i++) {
      add(
        CircleArc(
          color: color[i],
          startAngle: i * sweep,
          sweepAngle: sweep,
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

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  final circlePaint = Paint();

  final Color color;
  final double startAngle;
  final double sweepAngle;

  CircleArc({required this.color, required this.startAngle, required this.sweepAngle})
      : super(anchor: Anchor.center);

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;

    addHitBox();

    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      startAngle,
      sweepAngle,
      false,
      circlePaint
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );

    super.render(canvas);
  }

  addHitBox() {
    final center = size / 2;
    final radius = size.x / 2;
    const precision = 8;
    final segment = sweepAngle / (precision - 1);
    List<Vector2> vertices = [];

    for (int i = 0; i < precision; i++) {
      final thisSegment = startAngle + segment * i;
      vertices.add(
        center + Vector2(math.cos(thisSegment), math.sin(thisSegment)) * radius,
      );
    }

    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = startAngle + segment * i;
      vertices.add(
        center +
            Vector2(math.cos(thisSegment), math.sin(thisSegment)) *
                (radius - parent.thickness),
      );
    }

    add(
      PolygonHitbox(vertices, collisionType: CollisionType.passive),
    );
  }
}
