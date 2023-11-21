import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_netease_music/anims/record_anim.dart';
import 'package:flutter_netease_music/anims/needle_anim.dart';
import 'package:flutter_netease_music/player_page.dart';

void main() => runApp(const MyApp());

// final GlobalKey<PlayerState> musicPlayerKey = GlobalKey();

const String coverArt =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEKU9rkbdInt9fPTlJMjT_gbwlyBqbE60zELhHy_A2yMsJkBmDTw';
const String mp3Url =
    'https://wj.kumeiwp.com:912/wj/bl/2023/04/02/e5aff12ad6cc061384d7af317ce06a64.mp3?t=1698197979&key=3b2bda06a77e41c39e7f';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicPlayerExample(),
    );
  }
}

class MusicPlayerExample extends StatefulWidget {
  const MusicPlayerExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MusicPlayerExampleState();
  }
}

class _MusicPlayerExampleState extends State<MusicPlayerExample>
    with TickerProviderStateMixin {
  // _MusicPlayerExampleState({super.key});
  late AnimationController controller_record;
  late Animation<double> animation_record;
  late Animation<double> animation_needle;
  late AnimationController controller_needle;
  final _rotateTween = new Tween<double>(begin: -0.15, end: 0.0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    controller_record = AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animation_record =
        CurvedAnimation(parent: controller_record, curve: Curves.linear);

    controller_needle = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation_needle =
        CurvedAnimation(parent: controller_needle, curve: Curves.linear);

    animation_record.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller_record.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controller_record.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            image: DecorationImage(
              image: Image.asset("images/bg.jpg").image,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(137, 0, 0, 0),
                BlendMode.overlay,
              ),
            ),
          ),
        ),
        Container(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Opacity(
            opacity: 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
          ),
        )),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Container(
              child: const Text(
                'Shape of You - Ed Sheeran',
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
          body: Stack(
            alignment: const FractionalOffset(0.5, 0.0),
            children: <Widget>[
              Stack(
                alignment: const FractionalOffset(0.7, 0.1),
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    child: RotateRecord(
                      animation: _commonTween.animate(controller_record),
                    ),
                  ),
                  PivotTransition(
                    turns: _rotateTween.animate(controller_needle),
                    alignment: FractionalOffset.topLeft,
                    child: SizedBox(
                      width: 100.0,
                      child: Image.asset("images/play_needle.png"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Player(
                  onError: (e) {
                    // Scaffold.of(context).showSnackBar(
                    //   new SnackBar(
                    //     content: new Text(e),
                    //   ),
                    // );
                  },
                  onPrevious: () {},
                  onNext: () {},
                  onCompleted: () {},
                  onPlaying: (isPlaying) {
                    if (isPlaying) {
                      controller_record.forward();
                      controller_needle.forward();
                    } else {
                      controller_record.stop(canceled: false);
                      controller_needle.reverse();
                    }
                  },
                  color: Colors.white,
                  audioUrl: mp3Url,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller_record.dispose();
    controller_needle.dispose();
    super.dispose();
  }
}
