import 'package:flutter/material.dart';
import 'thread_info.dart';
import 'thread_list.dart';

// スレッド画面
class ThreadScreen extends StatelessWidget {
  // スレッド情報
  final ThreadInfo info;

  ThreadScreen({@required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(info.title)),
      body: ThreadList(),
    );
  }
}
