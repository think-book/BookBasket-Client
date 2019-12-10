import 'package:flutter/material.dart';
import 'package:bookbasket/forum/thread_message.dart';
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/forum/message_to_add.dart';
import 'package:bookbasket/forum/message_post_exception.dart';

// スレッドのListViewを返すWidget
class ThreadList extends StatefulWidget {
  final int id;

  ThreadList({@required this.id});

  @override
  ThreadListState createState() => new ThreadListState(id: id);
}

class ThreadListState extends State<ThreadList> {
  List<ThreadMessage> messages = [];
  final _textEditingController = TextEditingController();
  int _maxLines;
  final int id;
  // final int userId = 1;
  final _formKey = GlobalKey<FormState>();
  ThreadListState({@required this.id});

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
      // TextFieldに改行が2つ以上入っていたら、16行以上になるので、16行までに止める。
      _maxLines =
          '\n'.allMatches(_textEditingController.text).length >= 15 ? 16 : null;
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
            title: Text('user: ${messages[index].userName}'),
            subtitle: Text(messages[index].message),
            onTap: () {/* react to the tile being tapped */},
          ));
    };

    var listview = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 80.0),
        itemBuilder: listviewItemBuilder,
        itemCount: messages.length);

    var field = Row(children: <Widget>[
      Flexible(
          child: TextFormField(
        controller: _textEditingController,
        decoration: const InputDecoration(
          hintText: 'Enter a message',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter a message';
          }
          return null;
        },
        maxLines: _maxLines,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      )),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(
            icon: new Icon(Icons.send),
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                _handleSubmit(_textEditingController.text);
                _textEditingController
                  ..clearComposing()
                  ..clear();
              }
            },
          ))
    ]);

    var form = Form(
            key: _formKey,
            child: Container(
              color: Colors.grey[100],
              child: field,
            ));

    return Stack(children: <Widget>[
      Align(
        alignment: Alignment.bottomCenter,
        child: listview,
      ),
      new Divider(
        height: 1.0,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: form,
      )
    ]);
  }

  void _handleSubmit(String message) async {
      var client = new BookClient();
      MessageToAdd newMessageToAdd = new MessageToAdd(
        message: message,
      );

      try {
        var result = await client.postMessage(id, newMessageToAdd: newMessageToAdd);
        _getThreadMessage();
      } on MessagePostException catch (e) {
        print(e.errorMessage());
        // ここでdialogとか表示したい
      }
  }

  void _getThreadMessage() async {
    var client = new BookClient();
    var messages = await client.getThreadMessages(id);
    setState(() {
      this.messages = messages;
    });
  }
}
