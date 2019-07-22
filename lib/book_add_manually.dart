import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookDetail {
  final String ISBN;
  final String title;
  final String description;

  BookDetail({
    this.ISBN,
    this.title,
    this.description,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return new BookDetail(
      title: json['title'],
      ISBN: json['ISBN'].toString(),
      description: json['description'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['ISBN'] = ISBN;
    map['description'] = description;

    return map;
  }
}

Future<BookDetail> createBookToAdd(String url, Map body) async {
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    return BookDetail.fromJson(json.decode(response.body));
  }

  print(response.body);
  return null;
//  throw new Exception("Failed to create a post.");
}

class BookAddScreen extends StatefulWidget {
  String bookTitle;
  int bookISBN;

//  BookAddScreen({@required this.bookTitle, @required this.bookISBN});

  @override
  BookAddScreenState createState() =>
      new BookAddScreenState();
}

class BookAddScreenState extends State<BookAddScreen> {
  String bookTitle;
  String bookISBN;
  String bookDescription = "";

  final _formKey = GlobalKey<FormState>();

//  @override
//  void initState() {
//    makeGetRequest();
//  }

  BookAddScreenState();

  Widget build(BuildContext context){
    return Material(
      child: Column(
        children: <Widget>[
          fancyHeader(),
          formBuilder(),
        ],
      ),

    );
  }

  Stack fancyHeader(){
    return Stack( children: <Widget>[
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
        title: Text("Add a new book"),
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

  Form formBuilder(){
    return Form(
    key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
            onSaved: (value){
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

              if (value.isEmpty | (value.length!=13) | (int.tryParse(value)==null)) {
                return 'Enter a 13-digit ISBN.';
              }
              return null;
            },
            onSaved: (value){
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
            onSaved: (value){
              bookDescription = value;
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: (){
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate() ){

                  _formKey.currentState.save();
                  BookDetail bookDetail = new BookDetail(
                    title: bookTitle, ISBN: bookISBN, description: bookDescription,
                  );
                  var result = createBookToAdd("http://localhost:8080/books", bookDetail.toMap());
//                  if(result == null){
//                    print("Book failed to add."); // show book was not added message
//                  }
                  Navigator.pop(context);
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