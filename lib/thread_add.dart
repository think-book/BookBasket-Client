import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/forum/message_to_add.dart';
import 'package:bookbasket/forum/message_post_exception.dart';

class ThreadToAdd {
  final String userId;
  final String title;
  final String message;

  int threadId = 0;

  ThreadToAdd({
    this.userId, 
    this.title, 
    this.message, 
    this.threadId});

  factory ThreadToAdd.fromJson(Map<String, dynamic> json) {
    return ThreadToAdd(
      userId: json['userId'],
      title: json['title'],
      threadId: json['id'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;

    return map;
  }
}

Future<ThreadToAdd> addThread(int bookISBN, int userID, String title, String message) async {
  var client = new BookClient();

  ThreadToAdd newThreadToAdd = new ThreadToAdd(userId: userID.toString(), title: title, message: message);
  MessageToAdd newMessageToAdd = new MessageToAdd(
        userId: userID,
        message: message,
      );

  try {
    var response1 = await client.postThread(bookISBN, newThreadToAdd: newThreadToAdd);
    var response2 = await client.postMessage(response1.threadId, newMessageToAdd: newMessageToAdd);
    
  } on ThreadAddException catch (e) {
    print(e.errorMessage());
  } on MessagePostException catch (e){
    print(e.errorMessage());
  }
}

