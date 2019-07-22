import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'thread_message.dart';

// スレッドのListViewを返すWidget
class ThreadList extends StatefulWidget {
  final int id;

  ThreadList({@required this.id});

  @override
  ThreadListState createState() => new ThreadListState(id: id);
}

class ThreadListState extends State<ThreadList> {
  List<ThreadMessage> messages = [];
  final int id;

  @override
  void initState() {
    _getThreadMessage();
  }

  ThreadListState({@required this.id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text('user: ${messages[index].userID}'),
                subtitle: Text(messages[index].message),
                onTap: () {/* react to the tile being tapped */},
              ));
        },
        itemCount: messages.length);
  }

  void _getThreadMessage() async {
    //androidのときはこっち（推奨）
    //final response = await http.get('http://10.0.2.2:8080/threads/1');
    //iOSのときはこっち（授業的には非推奨だが速い）
    final response =
        await http.get('http://localhost:8080/threads/' + id.toString());
    if (response.statusCode == 200) {
      setState(() {
        Iterable lst = jsonDecode(response.body);
        messages = lst.map((json) => ThreadMessage.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load thread messages');
    }
  }
}
