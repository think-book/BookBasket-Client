import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/book_detail_screen.dart';
import 'package:bookbasket/book_add_screen.dart';

class Book {
  final String title;
  final int ISBN;

  Book({
    this.title,
    this.ISBN,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return new Book(
      title: json['title'],
      ISBN: json['ISBN'],
    );
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
  static const Alignment my_bottomRight = Alignment(0.9, 0.9);

  @override
  void initState() {
    makeGetRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたの本棚'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xffd399c1),
                Color(0xff9b5acf),
                Color(0xff611cdf),
              ],
            ),
          ),
        ),
      ),

      body: Stack (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: new GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(serverResponse.length, (index) {
                return StructuredGridCell(context, serverResponse[index].title,
                    serverResponse[index].ISBN);
              }),
            ),
          ),
        ],
      ),
        
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context)
              .push(new MaterialPageRoute<String>(
            builder: (context) => BookAddScreen(),
          ))
              .then((String value) {
            if (value == 'magic') {
              setState(() {
                initState();
              });
            }
          }),
        },
        tooltip: 'Add a new book',
        backgroundColor: Color(0xff9b5acf),
        child: const Icon(Icons.add_box),
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
