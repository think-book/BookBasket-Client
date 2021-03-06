import 'package:flutter/material.dart';
import 'package:bookbasket/forum/thread_list.dart';

// スレッド画面
class ThreadScreen extends StatelessWidget {
  // スレッド情報
  final String title;

  // このidは各々のスレッドのidをさす
  final int id;

  ThreadScreen({@required this.title, @required this.id});


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
      body: Container(
              margin: EdgeInsets.symmetric(horizontal: (size.width - size.height < 0) ? 0 : (size.width - size.height) / 3),
              child: ThreadList(id: id)
              ),
    );
  }
}
