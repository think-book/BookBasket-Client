import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForumThread extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListState();
  }
}

class ListState extends State<ForumList> {
  List<Map<String, dynamic>> items = [];

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
                title: Text('user: ${items[index]['userID']}'),
                subtitle: Text(items[index]['message']),
                onTap: () {/* react to the tile being tapped */},
              ));
        },
        itemCount: items.length);
  }

  void _getThreadMessage() async {
    final response = await http.get('http://10.0.2.2:8080/threads/1');
    if (response.statusCode == 200) {
      setState(() {
        items = jsonDecode(response.body).cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load thread messages');
    }
  }
}
