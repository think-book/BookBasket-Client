import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*
Future<List<Post>> fetchPost() async {
 final response = await http.get('http://localhost:8080/api/v1/event');
  // final response = await http.get('http://d7ef45de.ngrok.io/api/v1/event');
  print(response.body);

  if (response.statusCode == 200) {
//    return Post.fromJson(jsonDecode(response.body));
      return compute(parseData, response.body);
  } else {
    throw Exception('Failed to load post');
  }
}*/


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
Future<String> createPost(String url, String json_to_send) async{
  final response =
  await http.post(url, body: json_to_send);

  if (response.statusCode == 200) {
    return('ok');
  }

  else{
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
  //List<Post> serverResponse = [new Post(id: 1, title: "cool book", memo: "foo"), new Post(id: 2, title: "awesome book", memo: "bar")];
  List<String> serverResponse = [];

 @override
 void initState() {
   //super.initState();
   _stringmakeGetRequest();
   //print(serverResponse);
//    debugPrint(response.first.title);
 }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: new GridView.count(
        crossAxisCount: 2,
        children: List.generate(serverResponse.length, (index) {
          return stringgetStructuredGridCell(serverResponse[index].replaceAll(r'},', '}'));
        }),
      ),
    );
  }

  /*
  _makeGetRequest() async {
    List<Post> response = await fetchPost();
    setState(() {
      serverResponse = response;
    });
  }*/

  _stringmakeGetRequest() async {
    List<String> response = await stringfetchPost();
    setState(() {
      serverResponse = response;
    });
  }
}

/*
Card getStructuredGridCell(Post post) {
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
                new Image(image: new AssetImage('res/img/book.png'), width: 80, height: 80,),
//                new Text(post.id.toString()),
                new Text(post.title, style: TextStyle(fontWeight: FontWeight.bold),),
                 new Text("Memo: "+ post.memo),
              ],
            ),
          )
        ],
      ));
}
*/

Card stringgetStructuredGridCell(String one_elm) {
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
                new Image(image: new AssetImage('res/img/book.png'), width: 80, height: 80,),
//                new Text(post.id.toString()),
                // 各々の要素をPostクラスに変換した後titleに対応する要素を引っ張ってくる
                // (正規表現でもいいですが、後で仕様が変わることを考えると
                // Postクラスに変換した方がいい？
                // というかここはできれば後でmain関数の外に出したい
                new Text(Post.fromJson(jsonDecode(one_elm)).title, style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          )
        ],
      ));
}

/*
以下動作確認用のmain関数の例

void main() {

  myfetchPost().then((resp)
  {
    print(resp.id);
  }
  );

  final String send = ' {"deadline": "2019-06-11T14:00:00+09:00", "title": "report", "memo": "shoganai"} ';
  my_Post_template payload = my_Post_template.fromJson(jsonDecode(send));
  createPost("http://localhost:8080/api/v1/event", send ).then((resp)
  {
    print(resp);
  }
  );
}
*/