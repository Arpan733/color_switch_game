import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  Player({this.radius = 15});

  final velocity = Vector2(0, 20);
  final gravity = 980.0;
  final jumpSpeed = -300.0;
  final double radius;

  @override
  void onMount() {
    position = Vector2.zero();
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    super.onMount();
  }

  @override
  void update(double dt) {
    position += velocity * dt;
    velocity.y += gravity * dt;

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      (size / 2).toOffset(),
      radius,
      Paint()..color = Colors.yellow,
    );

    super.render(canvas);
  }

  jump() {
    velocity.y = jumpSpeed;
  }
}
