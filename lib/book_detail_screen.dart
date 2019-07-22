import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 使っている関数、クラスなど
import 'package:bookbasket/book_detail.dart';

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
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: titleControler,
                  decoration: InputDecoration(
                      hintText: "スレッドの題名を入力", labelText: 'Thread Title'),
                ),
                new RaisedButton(
                  onPressed: () async {
                    // ユーザー登録が実装されたらuserID: userID.toString() とかしてURLを変える
                    ThreadToAdd newThreadToAdd = new ThreadToAdd(
                        userId: "1", title: titleControler.text);
                    createThreadToAdd(
                        "http://localhost:8080/books/" +
                            bookISBN.toString() +
                            "/threads",
                        body: newThreadToAdd.toMap());
                    setState(() {
                      getThread();
                      titleControler.text = "";
                    });
                  },
                  child: const Text("スレッド追加"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getThread() async {
    List<Thread> response = await fetchThreadsList(bookISBN.toString());
    setState(() {
      forums = response;
    });
  }

  getBookDetail() async {
    BookDetail response = await fetchBookDetail(bookISBN.toString());
    setState(() {
      bookDescription = response.description;
    });
  }
}
