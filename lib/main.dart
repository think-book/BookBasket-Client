import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 〜〜〜〜1ページ目の手続きの説明〜〜〜〜〜
//(1)home には　Stateful な　BodyWidgetをbodyとしてもつScaffold がある。(class MyApp)
//(2)BodyWidgetが

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

class Book_detail {
  final int ISBN;
  final String title;
  final String description;

  Book_detail({
    this.ISBN,
    this.title,
    this.description,
  });

  factory Book_detail.fromJson(Map<String, dynamic> json) {
    return new Book_detail(
      ISBN: json['ISBN'],
      title: json['title'],
      description: json['description'],
    );
  }
}

Future<Book_detail> fetchBook_detail(String ISBN) async {
  final response = await http.get('http://localhost:8080/books/' + ISBN);
  if (response.statusCode == 200) {
    Book_detail l = Book_detail.fromJson(jsonDecode(response.body));
    return l;
  }
}

Future<List<Book>> fetchBooks() async {
  final response = await http.get('http://localhost:8080/books');
  print(response.body);
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Book> books = l.map((model) => Book.fromJson(model)).toList();
    return books;
  }
}

Future<String> createPost(String url, String json_to_send) async {
  final response = await http.post(url, body: json_to_send);

  if (response.statusCode == 200) {
    return ('ok');
  } else {
    throw Exception('Failed to create a post');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node server demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Think Book')),
        body: BodyWidget(),
      ),
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
    //super.initState();
    _stringmakeGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: new GridView.count(
        crossAxisCount: 2,
        children: List.generate(serverResponse.length, (index) {
          return stringgetStructuredGridCell(
              context,
              serverResponse[index].title,
              serverResponse[index].ISBN.toString());
        }),
      ),
    );
  }

  _stringmakeGetRequest() async {
    List<Book> response = await fetchBooks();
    setState(() {
      serverResponse = response;
    });
  }
}

Card stringgetStructuredGridCell(
    BuildContext context, String one_elm, String ISBN) {
  return new Card(
      elevation: 1.5,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          // can add picture here
          new Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // new Icon(Icons.book),
                FlatButton(
                  //icon: Icon(Icons.add_a_photo),
                  child: (Image.asset('res/img/book.png')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(book_name: one_elm, book_ISBN: ISBN),
                      ),
                    );
                  },
                ),
                new Text(
                  //Post.fromJson(jsonDecode(one_elm)).title,
                  one_elm,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ));
}

class DetailScreen extends StatefulWidget {
  final String book_name;
  final String book_ISBN;

  DetailScreen({@required this.book_name, @required this.book_ISBN});

  @override
  _DetailScreenState createState() =>
      new _DetailScreenState(book_name: book_name, book_ISBN: book_ISBN);
}

class _DetailScreenState extends State<DetailScreen> {
  final String book_name;
  final String book_ISBN;

  String book_detail = "";

  _DetailScreenState({@required this.book_name, @required this.book_ISBN});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book_name),
        ),
        body: Center(
          child: Text(book_detail),
        ));
  }

  @override
  void initState() {
    //super.initState();
    _makeGetRequest();
  }

  _makeGetRequest() async {
    Book_detail response = await fetchBook_detail(book_ISBN);
    setState(() {
      book_detail = response.description;
    });
  }
}
