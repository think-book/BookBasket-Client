import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
}

// generate a list of posts about books from received json response
List<Post> parseData(String responseBody){
  var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  List<Post> list = parsed.map<Post>((json) => new Post.fromJson(json)).toList() ;
  return list;
}

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
  //final String deadline;
  final String title;
  final String memo;

  Post({this.id, this.title, this.memo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json['id'] as int,
      //deadline: json['deadline'],
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
        primarySwatch: Colors.red,
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
  List<Post> serverResponse = [new Post(id: 1, title: "cool book", memo: "foo"), new Post(id: 2, title: "awesome book", memo: "bar")];

 @override
 void initState() {
   super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: new GridView.count(
        crossAxisCount: 2,
        children: List.generate(serverResponse.length, (index) {
          return getStructuredGridCell(serverResponse[index]);
        }),
      ),
    );
  }
  
  _makeGetRequest() async {
    List<Post> response = await fetchPost();
    setState(() {
      serverResponse = response;
    });
  }
}


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
