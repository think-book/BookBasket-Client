import 'dart:async';

import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/forum/message_to_add.dart';
import 'package:bookbasket/forum/message_post_exception.dart';

class ThreadToAdd {
  // final String userId;
  final String title;
//  final String message;

  final int threadId;

  ThreadToAdd({
    this.title, 
//    this.message,
    this.threadId});

  factory ThreadToAdd.fromJson(Map<String, dynamic> json) {
    return ThreadToAdd(
      // userId: json['userId'],
      title: json['title'],
      threadId: json['id'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    // map["userId"] = userId;
    map["title"] = title;

    return map;
  }
}

Future<ThreadToAdd> addThread(int bookISBN, int userID, String title, String message) async {
  var client = new BookClient();

//  ThreadToAdd newThreadToAdd = new ThreadToAdd(title: title);
  MessageToAdd newMessageToAdd = new MessageToAdd(
        message: message,
      );

  try {
    var response1 = await client.postThread(bookISBN, title);
    var response2 = await client.postMessage(response1.threadId, newMessageToAdd: newMessageToAdd);
    
  } on ThreadAddException catch (e) {
    print(e.errorMessage());
  } on MessagePostException catch (e){
    print(e.errorMessage());
  }
}

