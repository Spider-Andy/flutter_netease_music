class Lyric {
  List<LyricSlice> slices;

  Lyric(this.slices);
}

class LyricSlice {
  static bool empty = true;

  late int inSecond; // 歌词片段开始时间
  late String slice; // 片段内容

  Lyric(int inSecond, String slice) {
    this.inSecond = inSecond;
    this.slice = slice;
  }
}
