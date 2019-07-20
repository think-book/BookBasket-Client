import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

Future<List<Book>> fetchBooksList() async {
  final response = await http.get('http://localhost:8080/books');
  //　コンソールに出力する用
  print(response.body);
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Book> books = l.map((model) => Book.fromJson(model)).toList();
    return books;
  }
}

class BookListScreen extends StatefulWidget {
  @override
  BookListScreenState createState() {
    return new BookListScreenState();
  }
}

class BookListScreenState extends State<BookListScreen> {
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
    List<Book> response = await fetchBooksList();
    setState(() {
      serverResponse = response;
    });
  }
}

Card StructuredGridCell(
    BuildContext context, String bookTitle, int bookISBN) {
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
                        builder: (context) => DetailScreen(bookTitle: bookTitle, bookISBN: bookISBN)
                      ),
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
