import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                                builder: (context) =>
                                    ThreadScreen(info: forums[index].title, id: forums[index].id),
                              ), /* react to the tile being tapped */
                            );
                          },
                        ));
                  },
                  itemCount: forums.length)),
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
                    try {
                      createThreadToAdd("http://localhost:8080/books/" + bookISBN.toString() +"/threads", body: newThreadToAdd.toMap());
                      setState(() {
                        // ThreadのIDは実際はサーバー側で違うものを付与してる可能性があるからここはサーバーと要相談
                        // もしサーバーに追加して良いか逐一問い合わせるなら、
                        // 以下を消してgetThread() で良いが、遅くなるのは懸念
                        forums.add(Thread(id: forums.length + 1,
                            userID: 1,
                            title: titleControler.text,
                            ISBN: bookISBN));
                        titleControler.text = "";
                      });
                      } catch (exception){
                      titleControler.text = "";
                      // ここでアラートとか出せたら良いですね
                    };
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