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
  final style = TextStyle(color: Colors.white);
  
  Widget build(BuildContext context){
    return Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          // put app logo here
          SizedBox(
            height: 155.0,
            child: Image.asset('res/img/logo.png'),
          ),

          formBuilder(),
          ],
        ),
    );
  }
          
  Form formBuilder() {
    var client = new BookClient();

    //username 記入欄
    final usernameField =  TextFormField(
      style: style,
      decoration: const InputDecoration(
        // icon: Icon(Icons.person_add),
        hintText: 'Enter a username.',
        hintStyle: TextStyle(color: Colors.white),
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.white),
      ),
      autovalidate: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Required field.';
        }
        return null;
      },
      onSaved: (String value){
        userName = value;
      },
    );

    //パスワード記入欄
    final passwordField = TextFormField(
      style: style,
      decoration: const InputDecoration(
        // icon: Icon(Icons.security),
        hintText: 'Enter a password.',
        hintStyle: TextStyle(color: Colors.white),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white),
      ),
      obscureText: true,
      autovalidate: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Required field.';
        }
        return null;
      },
      onSaved: (String value){
        password = value;
      },
    );

    final signupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        color: Colors.white ,
        textColor: Color(0xff9b5acf),
        child: const Text('Sign up'),
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
              // ここでerror dialogとか表示したい
            }
            */
            Navigator.of(context)
                  .push(new MaterialPageRoute<String>(
                builder: (context) => BookListScreen(),
              ));
          }
        },
      ),
    );
    
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // to create gap between widgets in GUI
          SizedBox(height: 45.0),
          //username 記入欄
          usernameField,
          // to create gap between widgets in GUI
          SizedBox(height: 25.0),
          //パスワード記入欄
          passwordField,
          //登録ボタン
          signupButton,
      ],),
    );
  }
}