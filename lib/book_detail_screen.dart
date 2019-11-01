import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbasket/api/client.dart';

// 使っている関数、クラスなど
import 'package:bookbasket/book_detail.dart';
import 'package:bookbasket/thread_add_screen.dart';

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
  List<Thread> forums = [];

  TextEditingController titleControler = new TextEditingController();

  @override
  void initState() {
    getThread();
    getBookDetail();
  }

  DetailScreenState({@required this.bookTitle, @required this.bookISBN});

  Widget build(BuildContext context) {
    var client = new BookClient();
    return Material(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              buildContainerTop(context),
              buildAppbar(context, bookTitle),
              buildPositioned(context, bookDescription),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "スレッド一覧",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    // ここで次のページに行く
                    return buildContainerMiddle(context, forums, index);
                  },
                  itemCount: forums.length)),
          // ここ以下はsetState()をしているので外に出しにくい気がしたので出してません
          Padding(
              padding: const EdgeInsets.all(25.0),
              child: FloatingActionButton(
                  child: new Icon(Icons.add_box),
                  backgroundColor: Color(0xff9b5acf),
                  onPressed: () => {
                        Navigator.of(context)
                            .push(new MaterialPageRoute<String>(
                          builder: (context) =>
                              ThreadAddScreen(bookISBN: bookISBN),
                        ))
                            .then((String value) {
                          print(value);
                          if (value == 'addedthread!') {
                            getThread();
                          }
                        }),
                      })),
        ],
      ),
    );
  }

  getThread() async {
    var client = new BookClient();
    List<Thread> forums = await client.getThreadList(bookISBN.toString());
    setState(() {
      this.forums = forums;
    });
  }

  getBookDetail() async {
    var client = new BookClient();
    BookDetail detail = await client.getBookDetail(bookISBN.toString());
    setState(() {
      this.bookDescription = detail.description;
    });
  }
}
