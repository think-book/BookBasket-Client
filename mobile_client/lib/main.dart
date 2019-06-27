import 'dart:async';
import 'dart:convert';

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_web/material.dart';
import 'package:http/http.dart' as http;

// 6月25 方針転換（みよし） レスポンスを全てStringで受け取る→Json各々要素のリストにする。ただしこの時List<String>
// →レンダリング時にStringをPostに変換してお好みの要素を取り出す

// ",\n"区切りでレスポンスのbodyは帰ってきてるみたい。
// この仕様は変わる可能性が高いので、サーバーの仕様が変わったら適宜変更する。
Future<List<String>> stringfetchPost() async {
  final response = await http.get('http://localhost:8080/api/v1/event');
  if (response.statusCode == 200) {
//    return Post.fromJson(jsonDecode(response.body));
    print(response.body);
    return response.body.trim().split("\n");
  } else {
    throw Exception('Failed to load post');
  }
}

// generate a list of posts about books from received json response
//　あとで使う（今はmain関数で変換する程度にしてるが処理が多くなるにつれ対応を考えなければならない。）
/*
List<Post> parseData(String responseBody){git
  var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  List<Post> list = parsed.map<Post>((json) => new Post.fromJson(json)).toList() ;
  return list;
}
*/

// この関数はまだサーバーの対応待ちでいいです
Future<String> createPost(String url, String json_to_send) async {
  final response = await http.post(url, body: json_to_send);

  if (response.statusCode == 200) {
    return ('ok');
  } else {
    throw Exception('Failed to create a post');
  }
}

class Post {
  final int id;
  final String title;
  final String memo;

  Post({this.id, this.title, this.memo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json['id'] as int,
      title: json['title'] as String,
      memo: json['memo'] as String,
    );
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
        appBar: AppBar(title: Text('Flutter Client')),
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
  List<String> serverResponse = [];

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
              context, serverResponse[index].replaceAll(r'},', '}'));
        }),
      ),
    );
  }

  _stringmakeGetRequest() async {
    List<String> response = await stringfetchPost();
    setState(() {
      serverResponse = response;
    });
  }
}

Card stringgetStructuredGridCell(BuildContext context, String one_elm) {
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
                        builder: (context) => DetailScreen(book_info: one_elm),
                      ),
                    );
                  },
                ),
                new Text(
                  Post.fromJson(jsonDecode(one_elm)).title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ));
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final String book_info;

  // In the constructor, require a Todo.
  DetailScreen({@required this.book_info});

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(Post.fromJson(jsonDecode(book_info)).title),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
