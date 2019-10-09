/*TO DO:
 * Create user_create_screen and user_create
 * Correct the navigation to show this page before book_list_screen.
*/

import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/book_list_screen.dart';


class UserCreateScreen extends StatefulWidget{

  @override
  UserCreateScreenState createState() => new UserCreateScreenState();
}

class UserCreateScreenState extends State<UserCreateScreen>{
  String userName;
  String password;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context){
    return Material(
      child: Column(
        children: <Widget>[
          formBuilder(),
          ],
      ),
    );
  }
          
  Form formBuilder() {
    var client = new BookClient();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          //username 記入欄
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person_add),
              hintText: 'Enter a username.',
              labelText: 'Username'
            ),
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Required field.';
              }
              return null;
            },
            onSaved: (String value){
              userName = value;
            },
          ),

          //パスワード記入欄
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.security),
              hintText: 'Enter a password.',
              labelText: 'Password',
            ),
            obscureText: true,
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Required field.';
              }
              return null;
            },
            onSaved: (String value){
              password = value;
            },
          ),
          
          //登録ボタン
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              color: Color(0xff9b5acf),
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  // あとで使うために
                  /*
                  UserDetailToAdd userDetailToAdd = new UserDetailToAdd(
                    name: username,
                    password: password,
                  );

                  try{
                    var result = await client.createUser(userDetailToAdd);
                  }
                  on UserAddException catch(e){
                    print(e.errorMessage());
                    // ここでdialogとか表示したい
                  }
                  */

                  Navigator.of(context)
                        .push(new MaterialPageRoute<String>(
                      builder: (context) => BookListScreen(),
                    ))
                        .then((String value) {
                      if (value == 'magic') {
                        setState(() {
                          initState();
                        });
                      }
                    });
                }
              },
              child: const Text('Sign up'),
              textColor: Colors.white,
            ),
          ),
      ],),
    );
  }
}