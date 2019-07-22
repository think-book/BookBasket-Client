import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// あとで使う予定
//import 'package:bookbasket/forum/thread_info.dart';

//次のページ
import 'package:bookbasket/forum/thread_screen.dart';

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

class ThreadsList {
  final List<Thread> forums;

  ThreadsList({
    this.forums,
  });

  factory ThreadsList.fromJson(List<dynamic> parsedJson) {
    List<Thread> forums = new List<Thread>();
    forums = parsedJson.map((i) => Thread.fromJson(i)).toList();

    return new ThreadsList(forums: forums);
  }
}

class Thread {
  final int id;
  final int userID;
  final String title;
  final int ISBN;

  Thread({
    this.id,
    this.userID,
    this.title,
    this.ISBN,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return new Thread(
      id: json['id'],
      userID: json['userID'],
      title: json['title'],
      ISBN: json['ISBN'],
    );
  }
}

Future<List<Thread>> fetchThreadsList(String ISBN) async {
  //本当は以下をを使うべきだがISBN200に対応するスレッドのリストは今の所サーバーに無いので常に100に対応するやつを表示
  final response =
      await http.get('http://localhost:8080/books/' + ISBN + '/threads');
  //final response = await http.get('http://localhost:8080/books/100/threads');
  //　コンソールに出力する用
  print(response.body);
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Thread> forums = l.map((model) => Thread.fromJson(model)).toList();
    return forums;
  }
}

class ThreadToAdd {
  final String userId;
  final String title;

  ThreadToAdd({this.userId, this.title});

  factory ThreadToAdd.fromJson(Map<String, dynamic> json) {
    return ThreadToAdd(
      userId: json['userId'],
      title: json['title'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;

    return map;
  }
}

Future<ThreadToAdd> createThreadToAdd(String url, {Map body}) async {
  final response = await http.post(url, body: body);
  print(response.body);
  if (response.statusCode == 200) {
    return ThreadToAdd.fromJson(json.decode(response.body));
  } else {
    throw new Exception("Error while fetching data");
  }
}

buildContainerTop(BuildContext context) {
  return (Container(
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
  ));
}

buildAppbar(BuildContext context, String bookTitle) {
  return (AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    title: Text(bookTitle),
  ));
}

buildPositioned(BuildContext context, String bookDescription) {
  return (Positioned(
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
  ));
}

buildContainerMiddle(BuildContext context, List<Thread> forums, int index) {
  return (Container(
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
      )));
}
