import 'package:meta/meta.dart';

// スレッドのメッセージを格納するクラス
class ThreadMessage {
  final int id;
  final String userName;
  final String message;

  ThreadMessage({
    @required this.id,
    @required this.userName,
    @required this.message,
  });

  factory ThreadMessage.fromJson(Map<String, dynamic> json) {
    return ThreadMessage(
      id: json['id'],
      userName: json['userName'],
      message: json['message'],
    );
  }
}
