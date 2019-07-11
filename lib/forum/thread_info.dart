import 'package:meta/meta.dart';

// スレッド情報を格納するクラス
@immutable
class ThreadInfo {
  final String title;

  ThreadInfo({@required this.title});

  factory ThreadInfo.fromJson(Map<String, dynamic> json) {
    return ThreadInfo(title: json['title']);
  }
}
