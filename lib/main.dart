import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './register_page.dart';
import './signin_page.dart';
import 'package:bookbasket/user_list_screen.dart';
import 'package:bookbasket/user_login_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Auth Demo',
//       home: MyHomePage(title: 'Firebase Auth Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   FirebaseUser user;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             child: RaisedButton(
//               child: const Text('Test registration'),
//               onPressed: () => _pushPage(context, RegisterPage()),
//             ),
//             padding: const EdgeInsets.all(16),
//             alignment: Alignment.center,
//           ),
//           Container(
//             child: RaisedButton(
//               child: const Text('Test SignIn/SignOut'),
//               onPressed: () => _pushPage(context, SignInPage()),
//             ),
//             padding: const EdgeInsets.all(16),
//             alignment: Alignment.center,
//           ),
//         ],
//       ),
//     );
//   }

//   void _pushPage(BuildContext context, Widget page) {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(builder: (_) => page),
//     );
//   }
// }


import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '技術書について気軽に質問できるWebアプリ',
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

          Scaffold(
            backgroundColor: Colors.transparent,
            body: new Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(60.0,60.0,60.0,30.0),
              child: EmailPasswordForm(),
            ),
          )
//          BookListScreen(userName: "hellboy",),
//          OtheruserBooklistScreen(userName: "hellboy",),
//          PublicBookListScreen(),
//          UserListScreen(),
        ]
      )
    );
  }
}
