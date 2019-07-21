import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbasket/api/client.dart';

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
