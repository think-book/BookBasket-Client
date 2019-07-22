import 'package:flutter/material.dart';
import 'thread_info.dart';
import 'thread_list.dart';

// スレッド画面
class ThreadScreen extends StatelessWidget {
  // スレッド情報
  //final ThreadInfo info;
  // 簡単のため、現段階ではStringでinfoを受け取ることとします（三好、7/14)
  final String info;

  // このidは各々のスレッドのidをさす
  final int id;

  ThreadScreen({@required this.info, @required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info),
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
      body: ThreadList(id: id),
    );
  }
}
