import 'package:meta/meta.dart';

// スレッドのメッセージを格納するクラス
class ThreadMessage {
  final int id;
  final int userID;
  final String message;

  ThreadMessage({
    @required this.id,
    @required this.userID,
    @required this.message,
  });

  factory ThreadMessage.fromJson(Map<String, dynamic> json) {
    return ThreadMessage(
      id: json['id'],
      userID: json['userID'],
      message: json['message'],
    );
  }
}
