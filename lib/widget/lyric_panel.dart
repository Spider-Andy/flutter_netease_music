import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_netease_music/model/lyric.dart';

typedef PositionChangeHandler = void Function(int second);

class LyricPanel extends StatefulWidget {
  final Lyric lyric;
  late PositionChangeHandler handler;

  LyricPanel(this.lyric, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _LyricState();
  }
}

class _LyricState extends State<LyricPanel> {
  int index = 0;
  LyricSlice? currentSlice;

  @override
  void initState() {
    super.initState();

    print("class: LyricState -> initState(); ");
    // 根据时间位置获取对应歌词
    widget.handler = ((position) {
      print("LyricPanel.handler---------------------------------------");
      print(position);
      LyricSlice slice = widget.lyric.slices[index];
      if (position > slice.inSecond) {
        index++;
        setState(() {
          currentSlice = slice;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          currentSlice != null ? currentSlice!.slice : "",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
