import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookbasket/forum/thread_message.dart';
import 'package:bookbasket/api/client.dart';

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
  ThreadListState({@required this.id});

  @override
  void initState() {
    _getThreadMessage();
  }

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
    var client = new BookClient();
    var messages = await client.getThreadMessages(id);
    setState(() {
      this.messages = messages;
    });
  }
}
