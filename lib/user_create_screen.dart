import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/user_create.dart';
import 'package:flushbar/flushbar.dart';
import 'package:bookbasket/user_list_screen.dart';

class UserCreateScreen extends StatefulWidget{

  @override
  UserCreateScreenState createState() => new UserCreateScreenState();
}

class UserCreateScreenState extends State<UserCreateScreen>{
  String userName;
  String password;
  RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_\-\.]{3,15}$');
  RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9_\-\.!]{8,15}$');
  bool isNameAlreadyInUse = false;

  final _formKey = GlobalKey<FormState>();
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final style = TextStyle(color: Colors.white);
//  final snackBar = SnackBar(
//            content: Text('Registration failed! :('),
//            action: SnackBarAction(
//              label: 'Okay',
//              onPressed: () {
//                // Some code
//              },
//            ),
//          );
  
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
        if (value.isEmpty || value.length < 3 || value.length > 15) {
          return '3文字以上15文字以下で入力してください。';
        }
        if ( ! usernameRegex.hasMatch(value) ){
          return '英数文字と 記号「_, -, .」 だけで入力してください。';
        }
//        if( isNameAlreadyInUse){
//          isNameAlreadyInUse = false;
//          return 'ユーザー名がすでに使われています。';
//        }
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

            User result;
            try{
              result = await client.registerUser(userDetailToRegister);
            }
            on UserRegistrationException catch(e){
              print(e.errorMessage());
              // ここでerror dialogとか表示したい
              flushBar(context, "同じユーザー名ですでに登録されています。");
//              Flushbar(
//                icon: Icon(Icons.error),
//                title:  "登録エラー:",
//                message:  "ユーザー名がすでに使用されています。",
//                duration:  Duration(seconds: 3),
//                backgroundColor: Colors.red,
//                boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
//              ).show(context);
              return;
//              _scaffoldKey.currentState.showSnackBar(snackBar);
              return;
            }
            on InternalServerErrorException catch(e){
              print(e.errorMessage());
              flushBar(context, "通信に失敗しました。");
              return;
            }

            Navigator.of(context)
                .push(new MaterialPageRoute<String>(
            builder: (context) => BookListScreen(userName: result.userName),
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

Future<Object> flushBar(BuildContext context, String message) {
  return Flushbar(
    icon: Icon(Icons.error),
    title: "登録エラー:",
    message: message,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    backgroundColor: Colors.red,
    boxShadows: [BoxShadow(
      color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)
    ],
  ).show(context);
}