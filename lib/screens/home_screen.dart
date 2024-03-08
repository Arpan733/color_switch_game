import 'dart:math' as math;

import 'package:color_switch_game/main.dart';
import 'package:color_switch_game/screens/game_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              const Center(
                child: Text(
                  "COL   R\nSWITCH",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    letterSpacing: 5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: MediaQuery.of(context).size.width * 0.52,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Transform.rotate(
                    angle: controller.value * 2 * math.pi,
                    child: Image.asset(
                      'assets/images/circle.png',
                      width: 55,
                      height: 55,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    size: Vector2(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              );

              if (result != null) {
                setState(() {});
              }
            },
            child: Container(
              height: 70,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: const Center(
                child: Text(
                  'Play',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (s != 0)
            Center(
              child: Text(
                'Last Score: $s',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
