import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent with CollisionCallbacks {
  final starsPaint = Paint();
  late Sprite starSprite;

  StarComponent({required super.position})
      : super(
          size: Vector2(30, 30),
          anchor: Anchor.center,
          key: ComponentKey.named(
              (DateTime.now().microsecondsSinceEpoch + Random().nextInt(10000))
                  .toString()),
        );

  @override
  Future<void> onLoad() async {
    starSprite = await Sprite.load('star.png');

    add(CircleHitbox(
      radius: size.x / 2,
      collisionType: CollisionType.active,
    ));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    starSprite.render(
      canvas,
      size: size,
    );

    super.render(canvas);
  }

  showCollectEffect() {
    removeFromParent();

    final rnd = Random();
    Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 100;

    parent!.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 0.8,
          generator: (i) => AcceleratedParticle(
            speed: randomVector2(),
            acceleration: randomVector2(),
            child: RotatingParticle(
              to: rnd.nextDouble() * pi * 2,
              child: ComputedParticle(
                renderer: (c, particle) {
                  starSprite.render(
                    c,
                    size: size * (1 - particle.progress),
                    anchor: Anchor.center,
                    overridePaint: starsPaint
                      ..color = Colors.white.withOpacity(1 - particle.progress),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
