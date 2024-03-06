import 'package:color_switch_game/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      size: Vector2(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  final Vector2 size;

  const GamePage({super.key, required this.size});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late MyGame myGame;

  @override
  void initState() {
    myGame = MyGame(size: widget.size);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GameWidget(
                game: myGame,
              ),
            ),
            if (!myGame.isPause)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        myGame.pauseGameEngine();
                      });
                    },
                    icon: Icon(
                      myGame.isPause ? Icons.play_arrow_outlined : Icons.pause_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: myGame.score,
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  )
                ],
              ),
            if (myGame.isPause)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Pause!!!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          myGame.resumeGameEngine();
                        });
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
