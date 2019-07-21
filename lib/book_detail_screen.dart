import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/forum/thread_info.dart';

// 使っている関数、クラスなど
import 'package:bookbasket/book_detail.dart';

//次のページ
import 'package:bookbasket/forum/thread_screen.dart';

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
  List<Forum> forums = [];

  @override
  void initState() {
    makeGetRequest();
  }

  DetailScreenState({@required this.bookTitle, @required this.bookISBN});

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffd399c1),
                        Color(0xff9b5acf),
                        Color(0xff611cdf),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: Text(bookTitle),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 20,
                right: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  bookDescription,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                  ),
                ),
              )
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
                    return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black38),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text('user: ${forums[index].id}'),
                          subtitle: Text(forums[index].title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThreadScreen(
                                    info: ThreadInfo(
                                        title: forums[index].title,
                                        id: forums[index].id)),
                              ), /* react to the tile being tapped */
                            );
                          },
                        ));
                  },
                  itemCount: forums.length)),
        ],
      ),
    );
  }

  makeGetRequest() async {
    var client = new BookClient();
    List<Forum> forums = await client.getForum(bookISBN.toString());
    BookDetail detail = await client.getBookDetail(bookISBN.toString());
    setState(() {
      this.forums = forums;
      bookDescription = detail.description;
    });
  }
}
