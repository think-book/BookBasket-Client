import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Post> fetchPost() async {
  final response =
  await http.get('http://localhost:8080/api/v1/event/1');
  print(response.body);

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

Future<String> fetchAllPost() async{
  final response =
  await http.get('http://localhost:8080/api/v1/event');
  int i = 3;
  if (response.statusCode == 200) {
    return (response.body);
  } else {
    throw Exception('Failed to load post');
  }

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
    return Post(
      id: json['id'],
      //deadline: json['deadline'],
      title: json['title'],
      memo: json['memo'],
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
  List<String> serverResponse = ['Server Response', 'hi'];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Send request to server'),
                onPressed: () {
                  _makeGetRequest();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(serverResponse[1]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _makeGetRequest() async {
    String response = await fetchAllPost();
    List<String> my_jsons = response.split(',');
    print(my_jsons);

    setState(() {
      //serverResponse = response;
    });
  }
}

