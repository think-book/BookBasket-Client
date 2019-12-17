import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookbasket/public_booklist_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThinkBookClientApp',
      debugShowCheckedModeBanner: false,
      home: Stack(
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

//          Scaffold(
//            backgroundColor: Colors.transparent,
//            body: new Container(
//              color: Colors.transparent,
//              padding: const EdgeInsets.fromLTRB(60.0,60.0,60.0,30.0),
//              child: UserLoginScreen(),
//            ),
//          )
          BookListScreen(userName: "hellboy",),
//          PublicBookListScreen(),
        ]
      )
    );
  }
}
