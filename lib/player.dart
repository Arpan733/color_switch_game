import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  Player({
    required super.position,
    this.radius = 15,
  });

  final velocity = Vector2(0, 20);
  final gravity = 980.0;
  final jumpSpeed = -300.0;
  final double radius;

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
      Paint()..color = Colors.yellowAccent,
    );

    super.render(canvas);
  }

  jump() {
    velocity.y = jumpSpeed;
  }
}
