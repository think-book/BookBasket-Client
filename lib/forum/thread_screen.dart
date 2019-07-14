import 'package:flutter/material.dart';
import 'thread_info.dart';
import 'thread_list.dart';

// スレッド画面
class ThreadScreen extends StatelessWidget {
  // スレッド情報
  //final ThreadInfo info;
  // 簡単のため、現段階ではStringでinfoを受け取ることとします（三好、7/14)
  final String info;

  ThreadScreen({@required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(info)),
      body: ThreadList(),
    );
  }
}
