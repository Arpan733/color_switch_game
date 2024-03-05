import 'package:color_switch_game/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player myPlayer;
  late Vector2 s;

  @override
  void onMount() {
    s = size;
    add(myPlayer = Player(s: s));

    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();

    super.onTapDown(event);
  }
}
