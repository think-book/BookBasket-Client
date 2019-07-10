import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

Future<BookDetail> fetchBookDetail(String book_ISBN) async {
  final response = await http.get('http://localhost:8080/books/' + book_ISBN);
  if (response.statusCode == 200) {
    BookDetail ret = BookDetail.fromJson(jsonDecode(response.body));
    return ret;
  }
}

// 未使用　これから使う
Future<String> createPost(String url, String json_to_send) async {
  final response = await http.post(url, body: json_to_send);

  if (response.statusCode == 200) {
    return ('ok');
  } else {
    throw Exception('Failed to create a post');
  }
}

class DetailScreen extends StatefulWidget {
  final String book_title;
  final int book_ISBN;

  DetailScreen({@required this.book_title, @required this.book_ISBN});

  @override
  DetailScreenState createState() =>
      new DetailScreenState(book_title: book_title, book_ISBN: book_ISBN);
}

class DetailScreenState extends State<DetailScreen> {
  final String book_title;
  final int book_ISBN;
  String book_description = "";

  @override
  void initState() {
    makeGetRequest();
  }

  DetailScreenState({@required this.book_title, @required this.book_ISBN});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book_title),
        ),
        body: Center(
          child: Text(book_description),
        ));
  }

  makeGetRequest() async {
    BookDetail response = await fetchBookDetail(book_ISBN.toString());
    setState(() {
      book_description = response.description;
    });
  }
}
