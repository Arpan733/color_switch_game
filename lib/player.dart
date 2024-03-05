import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  final velocity = Vector2(0, 20);
  final gravity = 980.0;
  final jumpSpeed = -300.0;

  final Vector2 s;

  Player({required this.s});

  @override
  void onMount() {
    position = Vector2(s.x * 0.25, 150);

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
    canvas.drawCircle(position.toOffset(), 15, Paint()..color = Colors.yellow);

    super.render(canvas);
  }

  jump() {
    velocity.y = jumpSpeed;
  }
}