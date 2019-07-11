import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'thread_message.dart';

// スレッドのListViewを返すWidget
class ThreadList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ThreadListState();
  }
}

class ThreadListState extends State<ThreadList> {
  List<ThreadMessage> messages = [];

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
    final response = await http.get('http://10.0.2.2:8080/threads/1');
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
