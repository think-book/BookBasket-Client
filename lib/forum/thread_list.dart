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
  final _textEditingController = TextEditingController();
  int _maxLines;

  @override
  void initState() {
    _getThreadMessage();
    _textEditingController.addListener(_textEditListener);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textEditListener);
    _textEditingController.dispose();
    super.dispose();
  }

  // TextFieldになにか変更があったら呼ばれる
  void _textEditListener() {
    setState(() {
      // TextFieldに改行が2つ以上入っていたら、3行以上になるので、3行までに止める。
      _maxLines = '\n'.allMatches(_textEditingController.text).length >= 2 ? 3 : null;
    });
  }


  @override
  Widget build(BuildContext context) {

    var listviewItemBuilder = (BuildContext context, int index) {
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
        };
    var listview = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 80.0),
      itemBuilder: listviewItemBuilder,
      itemCount: messages.length
    );

    var field = Row(
            children: <Widget> [
                Flexible(
                        child: TextFormField(
                                controller: _textEditingController,
                                decoration: const InputDecoration(
                                        hintText: 'Enter a message',
                                ),
                                maxLines: _maxLines,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                        )
                ),
                Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: new IconButton(
                                icon: new Icon(Icons.send),

                                onPressed: ()=> {},//_handleSubmit(_chatController.text),
                        )
                )
            ]
            );

    return Stack(
            children: <Widget>[
                listview,
                new Divider(
                        height: 1.0,
                ),
                Positioned(
                        height: 80.0,
                        left: 0.0,
                        right: 0.0,
                        bottom: .0,
                        child: field,
                )
            ]
    );

  }

  void _getThreadMessage() async {
      //androidのときはこっち（推奨）
      //final response = await http.get('http://10.0.2.2:8080/threads/1');
      //iOSのときはこっち（授業的には非推奨だが速い）
      final response = await http.get('http://localhost:8080/threads/1');
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
