import 'package:flutter/material.dart';

// あとで使う予定
//import 'package:bookbasket/forum/thread_info.dart';

//次のページ
import 'package:bookbasket/forum/thread_screen.dart';

class BookDetail {
  final int ISBN;
  final String title;
  final String description;

  BookDetail({
    this.ISBN,
    this.title,
    this.description,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return new BookDetail(
      ISBN: json['ISBN'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class ThreadList {
  final List<Thread> forums;

  ThreadList({
    this.forums,
  });

  factory ThreadList.fromJson(List<dynamic> parsedJson) {
    List<Thread> forums = new List<Thread>();
    forums = parsedJson.map((i) => Thread.fromJson(i)).toList();

    return new ThreadList(forums: forums);
  }
}

class Thread {
  final int id;
  final String userName;
  final String title;
  final int ISBN;

  Thread({
    this.id,
    this.userName,
    this.title,
    this.ISBN,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return new Thread(
      id: json['id'],
      userName: json['userName'],
      title: json['title'],
      ISBN: json['ISBN'],
    );
  }
}

buildContainerTop(BuildContext context) {
  return (Container(
    height: MediaQuery.of(context).size.height * 0.3,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffd399c1),
            Color(0xff9b5acf),
            Color(0xff611cdf),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        )),
  ));
}

buildAppbar(BuildContext context, String bookTitle) {
  return (AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    title: Text(bookTitle),
  ));
}

buildPositioned(BuildContext context, String bookDescription) {
  return (Positioned(
    top: MediaQuery.of(context).size.height * 0.15,
    left: 20,
    right: MediaQuery.of(context).size.width * 0.3,
    child: Text(
      bookDescription,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 22,
      ),
    ),
  ));
}

buildContainerMiddle(BuildContext context, List<Thread> forums, int index) {
  return (Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black38),
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.account_circle),
        title: Text('user: ${forums[index].userName}'),
        subtitle: Text(forums[index].title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThreadScreen(
                  title: forums[index].title, id: forums[index].id),
            ), /* react to the tile being tapped */
          );
        },
      )));
}
