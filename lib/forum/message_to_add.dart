class MessageToAdd {
  // final int userId;
  final String message;

  MessageToAdd({this.message});

  factory MessageToAdd.fromJson(Map<String, dynamic> json) {
    return MessageToAdd(
      // userId: json['userId'],
      message: json['message'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    // map["userId"] = userId.toString();
    map["message"] = message;

    return map;
  }
}
