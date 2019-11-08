import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/book_add.dart';

class BookAddScreen extends StatefulWidget {
  @override
  BookAddScreenState createState() => new BookAddScreenState();
}

class BookAddScreenState extends State<BookAddScreen> {
  String bookTitle;
  String bookISBN;
  String bookDescription = "";

  final _formKey = GlobalKey<FormState>();

  BookAddScreenState();

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          fancyHeader(),
          formBuilder(),
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
          title: Text("Add a new book"), //　色を白にしたい
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: 20,
          right: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            bookDescription,
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
    var client = new BookClient();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 三つの記入欄とボタン
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.book),
              hintText: 'Enter the title of the book.',
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
              bookTitle = value;
            },
          ),

          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.confirmation_number),
              hintText: 'Enter the 13 digit ISBN of the book.',
              labelText: 'ISBN:',
            ),
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty |
                  (value.length != 13) |
                  (int.tryParse(value) == null)) {
                return 'Enter a 13-digit ISBN.';
              }
              return null;
            },
            onSaved: (value) {
              bookISBN = value; //int.parse(value);
            },
          ),

          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              hintText: 'Enter some description of the book.',
              labelText: 'Description:',
            ),
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter some text.';
              }
              return null;
            },
            onSaved: (value) {
              bookDescription = value;
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
                  BookDetailToAdd bookDetailToAdd = new BookDetailToAdd(
                    title: bookTitle,
                    ISBN: bookISBN,
                    description: bookDescription,
                  );

                  try{
                    var result = await client.postBook(bookDetailToAdd);
                  }
                  on BookAddException catch(e){
                    print(e.errorMessage());
                    // ここでdialogとか表示したい
                  }

                  Navigator.of(context).pop('magic');
                }
              },
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}
