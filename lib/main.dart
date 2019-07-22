import 'package:flutter/material.dart';

import 'book_list.dart';
import 'book_add_manually.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node server demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('あなたの本棚')),
        body: BodyWidget(),
        floatingActionButton: FloatingButton(),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: new FloatingActionButton(
        child: new Icon(Icons.add_box),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => BookAddScreen(),
            ),
          )
        }
      ),
    );
  }
}
