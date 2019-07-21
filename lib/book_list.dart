import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/book_detail_screen.dart';

class BooksList {
  final List<Book> books;

  BooksList({
    this.books,
  });

  factory BooksList.fromJson(List<dynamic> parsedJson) {
    List<Book> books = new List<Book>();
    books = parsedJson.map((i) => Book.fromJson(i)).toList();

    return new BooksList(books: books);
  }
}

class Book {
  final int id;
  final String title;
  final int ISBN;

  Book({
    this.id,
    this.title,
    this.ISBN,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return new Book(
      id: json['id'],
      title: json['title'],
      ISBN: json['ISBN'],
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  BodyWidgetState createState() {
    return new BodyWidgetState();
  }
}

class BodyWidgetState extends State<BodyWidget> {
  List<Book> serverResponse = [];

  @override
  void initState() {
    makeGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: new GridView.count(
        crossAxisCount: 2,
        children: List.generate(serverResponse.length, (index) {
          return StructuredGridCell(
              context, serverResponse[index].title, serverResponse[index].ISBN);
        }),
      ),
    );
  }

  makeGetRequest() async {
    var client = new BookClient();
    List<Book> response = await client.getBooks();
    setState(() {
      serverResponse = response;
    });
  }
}

Card StructuredGridCell(BuildContext context, String bookTitle, int bookISBN) {
  return new Card(
      elevation: 1.5,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: (Image.asset('res/img/book.png')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => ThreadList(),
                          builder: (context) => DetailScreen(
                              bookTitle: bookTitle, bookISBN: bookISBN)),
                    );
                  },
                ),
                new Text(
                  bookTitle,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ));
}
