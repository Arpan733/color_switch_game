import 'dart:async';

import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleRotator extends PositionComponent with HasGameRef<MyGame> {
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
    double circle = math.pi * 2;
    final sweep = circle / gameRef.gameColor.length;

    for (int i = 0; i < gameRef.gameColor.length; i++) {
      add(
        CircleArc(
          color: gameRef.gameColor[i],
          startAngel: i * sweep,
          sweepAngel: sweep,
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

  @override
  void render(Canvas canvas) {
    // final radius = (size.x / 2) - thickness;

    // canvas.drawArc(
    //   size.toRect(),
    //   0,
    //   3.13,
    //   false,
    //   Paint()
    //     ..color = Colors.blueAccent
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = thickness,
    // );

    // canvas.drawCircle(
    //   (size / 2).toOffset(),
    //   radius,
    //   Paint()
    //     ..color = Colors.blueAccent
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = thickness,
    // );

    super.render(canvas);
  }
}

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  final Color color;
  final double startAngel;
  final double sweepAngel;

  CircleArc({required this.color, required this.startAngel, required this.sweepAngel})
      : super(anchor: Anchor.center);

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;

    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      startAngel,
      sweepAngel,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );

    super.render(canvas);
  }
}
