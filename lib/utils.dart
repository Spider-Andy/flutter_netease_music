import 'package:flutter/services.dart';
import 'package:flutter_netease_music/model/lyric.dart';

class Utils {
  static Future<Lyric> getLyricFromTxt() async {
    List<LyricSlice> slices = [];
    return await rootBundle
        .loadString('images/lyric.txt')
        .then((String result) {
      List<String> list = result.split("\n");
      // print("lines:" + list.length.toString() + "");
      for (String line in list) {
        // print(line);
        if (line.startsWith("[")) {
          slices.add(getLyricSlice(line));
        }
      }
      Lyric lyric = Lyric(slices);
      return lyric;
    });
  }

  static LyricSlice getLyricSlice(String line) {
    LyricSlice lyricSlice = LyricSlice();
    lyricSlice.slice = line.substring(11);
    lyricSlice.inSecond =
        int.parse(line.substring(1, 3)) * 60 + int.parse(line.substring(4, 6));
    // print(lyricSlice.in_second.toString() + "-----" + lyricSlice.slice);
    return lyricSlice;
  }
}
