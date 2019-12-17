import 'package:bookbasket/user_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/user_login.dart';
import 'package:flushbar/flushbar.dart';

class UserLoginScreen extends StatefulWidget{

  @override
  UserLoginScreenState createState() => new UserLoginScreenState();
}

class UserLoginScreenState extends State<UserLoginScreen>{
  String userName;
  String password;
  RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_\-\.]{3,15}$');
  RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9_\-\.!]{8,15}$');

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
        hintText: 'ユーザー名',
        hintStyle: TextStyle(color: Colors.white),
        // labelText: 'Username',
        // labelStyle: TextStyle(color: Colors.white),
      ),
      autovalidate: false,
      validator: (value) {
        if (value.isEmpty || value.length < 3 || value.length > 15) {
          return '3文字以上15文字以下で入力してください。';
        }
        if ( ! usernameRegex.hasMatch(value) ){
          return '英数文字と 記号「_, -, .」 だけで入力してください。';
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
        // labelText: 'パスワード',
        // labelStyle: TextStyle(color: Colors.white),
      ),
      obscureText: true,
      autovalidate: false,
      validator: (value) {
        if (value.isEmpty || value.length < 8 || value.length > 15 ) {
          return '8文字以上15文字以下で入力してください。';
        }
        if ( ! passwordRegex.hasMatch(value) ){
          return '英数文字と 記号「_, -, ., !」 だけで入力してください。';
        }
        return null;
      },
      onSaved: (String value){
        password = value;
      },
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width/3,
        color: Colors.white ,
        textColor: Color(0xff9b5acf),
        child: const Text('ログイン'),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            // あとで使うために
            UserDetailToLogin userDetailToLogin = new UserDetailToLogin(
              username: userName,
              password: password,
            );

            try{
              var result = await client.loginUser(userDetailToLogin);

            }
            on UserLoginException catch(e){
              print(e.errorMessage());
              // ここでerror dialogとか表示したい
              flushBar(context, "ユーザー名かパスワードが間違っています");
//              Flushbar(
//                icon: Icon(Icons.error),
//                title:  "ログインエラー:",
//                message:  "認証に失敗しました。",
//                duration:  Duration(seconds: 3),
//                margin: EdgeInsets.all(8),
//                backgroundColor: Colors.red,
//                boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
//              ).show(context);
              return;
            }
            on InternalServerErrorException catch(e){
              print(e.errorMessage());
              flushBar(context, "通信に失敗しました。");
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
    
    final linkToSignUpPage = FlatButton(
      child: Text("アカウントの作成はこちらへ", style: style,),
      onPressed: () async{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserCreateScreen()),
        );
      },
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
          loginButton,
          linkToSignUpPage,
      ],),
    );
  }
}

Future<Object> flushBar(BuildContext context, String message) {
  return Flushbar(
    icon: Icon(Icons.error),
    title: "ログインエラー:",
    message: message,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    backgroundColor: Colors.red,
    boxShadows: [BoxShadow(
      color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)
    ],
  ).show(context);
}