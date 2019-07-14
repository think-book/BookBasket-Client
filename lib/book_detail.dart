import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// あとで使う予定
//import 'package:bookbasket/forum/thread_info.dart';

class BookDetail {
  final int ISBN;
  final String title;
  final String description;

  BookDetail({
    this.ISBN,
    this.title,
    this.description,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return new BookDetail(
      ISBN: json['ISBN'],
      title: json['title'],
      description: json['description'],
    );
  }
}

Future<BookDetail> fetchBookDetail(String bookISBN) async {
  final response = await http.get('http://localhost:8080/books/' + bookISBN);
  if (response.statusCode == 200) {
    BookDetail ret = BookDetail.fromJson(jsonDecode(response.body));
    return ret;
  }
}

class ForumsList {
  final List<Forum> forums;

  ForumsList({
    this.forums,
  });

  factory ForumsList.fromJson(List<dynamic> parsedJson) {
    List<Forum> forums = new List<Forum>();
    forums = parsedJson.map((i) => Forum.fromJson(i)).toList();

    return new ForumsList(forums: forums);
  }
}

class Forum {
  final int id;
  final int userID;
  final String title;
  final int ISBN;

  Forum({
    this.id,
    this.userID,
    this.title,
    this.ISBN,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return new Forum(
      id: json['id'],
      userID: json['userID'],
      title: json['title'],
      ISBN: json['ISBN'],
    );
  }
}

Future<List<Forum>> fetchForumsList(String ISBN) async {
  //本当は以下をを使うべきだがISBN200に対応するスレッドのリストは今の所サーバーに無いので常に100に対応するやつを表示
  //final response = await http.get('http://localhost:8080/books/' + ISBN + '/threads');
  final response = await http.get('http://localhost:8080/books/100/threads');
  //　コンソールに出力する用
  print(response.body);
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Forum> forums = l.map((model) => Forum.fromJson(model)).toList();
    return forums;
  }
}

