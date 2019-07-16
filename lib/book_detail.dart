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

Future<BookDetail> fetchBookDetail(String bookISBN) async {
  final response = await http.get('http://localhost:8080/books/' + bookISBN);
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
  final String bookTitle;
  final int bookISBN;

  DetailScreen({@required this.bookTitle, @required this.bookISBN});

  @override
  DetailScreenState createState() =>
      new DetailScreenState(bookTitle: bookTitle, bookISBN: bookISBN);
}

class DetailScreenState extends State<DetailScreen> {
  final String bookTitle;
  final int bookISBN;
  String bookDescription = "";

  @override
  void initState() {
    makeGetRequest();
  }

  DetailScreenState({@required this.bookTitle, @required this.bookISBN});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(bookTitle),
        ),
        body: Center(
          child: Text(bookDescription),
        ));
  }

  makeGetRequest() async {
    BookDetail response = await fetchBookDetail(bookISBN.toString());
    setState(() {
      bookDescription = response.description;
    });
  }
}
