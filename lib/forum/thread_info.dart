import 'package:meta/meta.dart';

// スレッド情報を格納するクラス
@immutable
class ThreadInfo {
  final String title;
  final int id;

  ThreadInfo({@required this.title, @required this.id});

  factory ThreadInfo.fromJson(Map<String, dynamic> json) {
    return ThreadInfo(title: json['title']);
  }
}
