import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/user_create.dart';

class UserCreateScreen extends StatefulWidget{

  @override
  UserCreateScreenState createState() => new UserCreateScreenState();
}

class UserCreateScreenState extends State<UserCreateScreen>{
  String userName;
  String password;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final style = TextStyle(color: Colors.white);
  final snackBar = SnackBar(
            content: Text('Registration failed! :('),
            action: SnackBarAction(
              label: 'Okay',
              onPressed: () {
                // Some code 
              },
            ),
          );
  
  Widget build(BuildContext context){
    final foreground = Material(
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

    return Stack(
      children: <Widget>[
        new Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xffd399c1),
                Color(0xff9b5acf),
                Color(0xff611cdf),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: new Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(60.0,60.0,60.0,30.0),
            child: foreground,
          ),
        )
      ]
    );
  }
          
  Form formBuilder() {
    var client = new BookClient();

    //username 記入欄
    final usernameField =  TextFormField(
      style: style,
      decoration: const InputDecoration(
        // icon: Icon(Icons.person_add),
        hintText: 'ユーザー名',
        hintStyle: TextStyle(color: Colors.white),
        // labelText: 'Username',
        // labelStyle: TextStyle(color: Colors.white),
      ),
      autovalidate: false,
      validator: (value) {
        if (value.isEmpty) {
          return '入力してください。';
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
        hintText: 'パスワード',
        hintStyle: TextStyle(color: Colors.white),
        // labelText: 'Password',
        // labelStyle: TextStyle(color: Colors.white),
      ),
      obscureText: true,
      autovalidate: false,
      validator: (value) {
        if (value.isEmpty) {
          return '入力してください。';
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
        minWidth: MediaQuery.of(context).size.width/3,
        color: Colors.white ,
        textColor: Color(0xff9b5acf),
        child: const Text('登録する'),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            // あとで使うために
            UserDetailToRegister userDetailToRegister = new UserDetailToRegister(
              username: userName,
              password: password,
            );

            try{
              var result = await client.registerUser(userDetailToRegister);
            }
            on UserRegistrationException catch(e){
              print(e.errorMessage());
              // ここでerror dialogとか表示したい
              _scaffoldKey.currentState.showSnackBar(snackBar);
              return;
            }

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