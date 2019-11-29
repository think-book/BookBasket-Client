import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bookbasket/book/thread_add.dart';

class ThreadAddScreen extends StatefulWidget {
  int bookISBN;

  ThreadAddScreen({@required this.bookISBN});

  @override
  ThreadAddScreenState createState() =>
      new ThreadAddScreenState(bookISBN: bookISBN);
}

class ThreadAddScreenState extends State<ThreadAddScreen> {
  String threadTitle;
  String message;
  final int bookISBN;

  final _formKey = GlobalKey<FormState>();

  ThreadAddScreenState({@required this.bookISBN});

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          fancyHeader(),
          new Expanded(child: formBuilder()),
          //formBuilder(),
        ],
      ),
    );
  }

  Stack fancyHeader() {
    return Stack(
      children: <Widget>[
        Container(

          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffd399c1),
                  Color(0xff9b5acf),
                  Color(0xff611cdf),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Add a new thread"), //　色を白にしたい
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: 20,
          right: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            "hi",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 22,
            ),
          ),
        )
      ],
    );
  }

  Form formBuilder() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 三つの記入欄とボタン
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.book),
              hintText: 'Enter a title',
              labelText: 'Title:',
            ),
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter some title.';
              }
              return null;
            },
            onSaved: (value) {
              this.threadTitle = value;
            },
          ),

          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: const InputDecoration(
              icon: Icon(Icons.confirmation_number),
              hintText: 'Enter a message.',
              labelText: 'Message',
            ),
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter a message';
              }
              return null;
            },
            onSaved: (value) {
              this.message = value; //int.parse(value);
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              color: Color(0xff9b5acf),
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  // userID が実装されたら二番目の引数をuserIDに変える
                  await addThread(bookISBN, 1, this.threadTitle, this.message);
                }

                Navigator.of(context).pop('addedthread!');
              },
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}
