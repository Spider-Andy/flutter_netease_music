import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netease_music/model/lyric.dart';
import 'package:flutter_netease_music/utils.dart';
import 'package:flutter_netease_music/widget/lyric_panel.dart';

class Player extends StatefulWidget {
  /// [AudioPlayer] 播放地址
  final String audioUrl;

  /// 音量
  final double volume;

  /// 错误回调
  final Function(String) onError;

  ///播放完成
  final Function() onCompleted;

  /// 上一首
  final Function() onPrevious;

  ///下一首
  final Function() onNext;

  final Function(bool) onPlaying;

  // final Key key;

  final Color color;

  /// 是否是本地资源
  final bool isLocal;

  const Player(
      {super.key,
      required this.audioUrl,
      required this.onCompleted,
      required this.onError,
      required this.onNext,
      required this.onPrevious,
      this.volume = 1.0,
      required this.onPlaying,
      this.color = Colors.white,
      this.isLocal = false});

  @override
  State<StatefulWidget> createState() {
    return PlayerState();
  }
}

class PlayerState extends State<Player> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = const Duration(seconds: 0);
  Duration position = const Duration(seconds: 0);
  late double sliderValue = 0.0;
  late Lyric lyric;

  // 歌词画板类
  LyricPanel? lyricPanel;

  @override
  void initState() {
    super.initState();
    print("Class: PlayerState => initState: audioUrl: \n" + widget.audioUrl);

    Utils.getLyricFromTxt().then((Lyric lyric) {
      // print("getLyricFromTxt:" + lyric.slices.length.toString());
      setState(() {
        this.lyric = lyric;
        // 初始化格式画板
        lyricPanel = LyricPanel(lyric);
      });
    });

    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen(((duration) {
      setState(() {
        this.duration = duration;

        sliderValue = (position.inSeconds / duration.inSeconds);
      });
    }));

    // 歌曲位置改变
    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        print("onPositionChanged---------------:$position");
        this.position = position;

        // 调用歌词中的处理功能
        lyricPanel?.handler(position.inSeconds);

        sliderValue = (position.inSeconds / duration.inSeconds);
      });
    });
  }

  @override
  void deactivate() {
    audioPlayer.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: _controllers(context),
    );
  }

  // 格式化时间
  String _formatDuration(Duration d) {
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    // print(d.inMinutes.toString() + "======" + d.inSeconds.toString());
    String format =
        "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
    return format;
  }

  // 时间进度条
  Widget _timer(BuildContext context) {
    var style = TextStyle(color: widget.color);
    print("------------- $position.inSeconds");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          position == null ? "--:--" : _formatDuration(position),
          style: style,
        ),
        Text(
          duration == null ? "--:--" : _formatDuration(duration),
          style: style,
        ),
      ],
    );
  }

  List<Widget> _controllers(BuildContext context) {
    print("----------------------- init... _controllers");

    return [
      lyricPanel ?? Text('未找到歌词'),
      const Divider(color: Colors.transparent),
      const Divider(
        color: Colors.transparent,
        height: 32.0,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              onPressed: () {
                widget.onPrevious();
              },
              icon: Icon(
                Icons.skip_previous,
                size: 32.0,
                color: widget.color,
              ),
            ),
            IconButton(
              onPressed: () {
                if (isPlaying) {
                  audioPlayer.pause();
                } else {
                  audioPlayer.play(
                    UrlSource(widget.audioUrl),
                    volume: widget.volume,
                  );
                }
                setState(() {
                  isPlaying = !isPlaying;
                  widget.onPlaying(isPlaying);
                });
              },
              padding: const EdgeInsets.all(0.0),
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 48.0,
                color: widget.color,
              ),
            ),
            IconButton(
              onPressed: widget.onNext,
              icon: Icon(
                Icons.skip_next,
                size: 32.0,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
      Slider(
        onChanged: (newValue) {
          int seconds = (duration.inSeconds * newValue).round();
          print("audioPlayer.seek: $seconds");
          audioPlayer.seek(Duration(seconds: seconds));
        },
        value: sliderValue ?? 0.0,
        activeColor: widget.color,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: _timer(context),
      ),
    ];
  }
}
