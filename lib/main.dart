import 'package:flutter/material.dart';
import 'book_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThinkBookClientApp',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('あたなの本棚'),
          flexibleSpace: Container(
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
        ),
        body: BookListScreen(),
      ),
    );
  }
}

