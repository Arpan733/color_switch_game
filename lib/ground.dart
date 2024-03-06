import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  static const String keyName = 'single_ground_key';
  late Sprite tapSprite;

  Ground({required super.position})
      : super(
          size: Vector2(200, 1),
          anchor: Anchor.center,
          key: ComponentKey.named(keyName),
        );

  @override
  Future<void> onLoad() async {
    tapSprite = await Sprite.load('tap.png');

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    tapSprite.render(
      canvas,
      anchor: anchor,
      position: Vector2(100, 50),
      size: Vector2(50, 50),
    );

    super.render(canvas);
  }
}
