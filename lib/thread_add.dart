import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:bookbasket/api/client.dart';

class ThreadToAdd {
  final String userId;
  final String title;

  ThreadToAdd({this.userId, this.title});

  factory ThreadToAdd.fromJson(Map<String, dynamic> json) {
    return ThreadToAdd(
      userId: json['userId'],
      title: json['title'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;

    return map;
  }
}

Future<ThreadToAdd> addThread(int bookISBN, String title) async {
  var client = new BookClient();

  ThreadToAdd newThreadToAdd = new ThreadToAdd(userId: "1", title: title);

  try {
    client.postThread(bookISBN, newThreadToAdd: newThreadToAdd);
  } on ThreadAddException catch (e) {
    print(e.errorMessage());
  }
}
