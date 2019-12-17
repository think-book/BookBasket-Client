import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/book_detail_screen.dart';
import 'package:bookbasket/book_add_screen.dart';
import 'package:bookbasket/user_list_screen.dart';
import 'package:bookbasket/public_booklist_screen.dart';

class Book {
  final String title;
  final int ISBN;

  Book({
    this.title,
    this.ISBN,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return new Book(
      title: json['title'],
      ISBN: json['ISBN'],
    );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
//  Choice(title: 'ログアウト', icon: Icons.exit_to_app),
  Choice(title: 'About Us', icon: Icons.people),
];

class BookListScreen extends StatefulWidget {
  String userName;

  BookListScreen({@required this.userName});
  @override
  BookListScreenState createState() {
    return new BookListScreenState(userName: userName);
  }
}

class BookListScreenState extends State<BookListScreen> {
  String userName;
  BookListScreenState({@required this.userName});

  List<Book> serverResponse = [];
  List<Image> googleImages = [];
  static const Alignment my_bottomRight = Alignment(0.9, 0.9);

  @override
  void initState() {
    makeGetRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userName+ 'の本棚'),
        automaticallyImplyLeading: false, // appBarのback buttonを隠す
        actions: <Widget>[
          //みんなの本棚へのボタン
          new IconButton(icon: new Icon(Icons.people),
            onPressed: (){
              Navigator.of(context).push(
                new MaterialPageRoute<String>(
                  builder: (context) => UserListScreen(),
                )
              ).then((String value) {
                if (value == '5678') {
                    //個人の本棚を更新する
                    initState();
                }
              });
            },
          ),

          new IconButton(icon: new Icon(Icons.public),
            onPressed: (){
              Navigator.of(context).push(
                  new MaterialPageRoute<String>(
                    builder: (context) => PublicBookListScreen(),
                  )
              ).then((String value) {
                if (value == '1234') {
                  //個人の本棚を更新する
                  initState();
                }
              });
            },
          ),

          // overflow menu
          PopupMenuButton<Choice>(
            // onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],

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

      body: Stack (
        children: <Widget>[
          Container(
//            margin: EdgeInsets.symmetric(horizontal: (size.width - size.height < 0) ? 0 : (size.width - size.height) / 3),
//            margin: EdgeInsets.symmetric(horizontal: (size.width % 280) / 3),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: new GridView.count(
                shrinkWrap: true,
                crossAxisCount: (size.width * 1.5 < size.height ) ? (size.width~/180) : (size.width~/260),
                children: List.generate(serverResponse.length, (index) {
                  return StructuredGridCell(context, serverResponse[index].title,
                      serverResponse[index].ISBN,
                      googleImages[index]);
                }),
              ),
            ),
          ),
        ],
      ),
        
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context)
              .push(new MaterialPageRoute<String>(
            builder: (context) => BookAddScreen(),
          ))
              .then((String value) {
            if (value == 'magic') {
              setState(() {
                initState();
              });
            }
          }),
        },
        tooltip: 'Add a new book',
        backgroundColor: Color(0xff9b5acf),
        child: const Icon(Icons.add_box),
      ),
    );
  }
  makeGetRequest() async {
    var client = new BookClient();
    List<Book> response = (await client.getBooks()).cast<Book>();
    List<Image> images = [];
    for(int index = 0; index < response.length; index++)
    {
      var ISBN = response[index].ISBN.toString();
      while(ISBN.length < 13)
      {
          ISBN = "0" + ISBN;
      }
      var picture = await client.getPicture(ISBN);
      images.add(picture);
    }
    setState(() {
      serverResponse = response;
      googleImages = images;
    });
  }
}

Card StructuredGridCell(BuildContext context, String bookTitle, int bookISBN, Image image) {
  final Size size = MediaQuery.of(context).size;
  return new Card(
      elevation: 1.5,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
//        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 20),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: FlatButton(
                    child: Image(
                      image: image.image,
                      width: min(size.width*0.15, 120 ) ,
        //                    height: ((size.width * 1.5  < size.height ) ? size.height * 0.10 : image.height),
                      fit: BoxFit.scaleDown,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                bookTitle: bookTitle, bookISBN: bookISBN)),
                      );
                    },
                  ),
                ),
                new Text(
                  bookTitle,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: size.height * 0.017),
                ),
              ],
            ),
          )
        ],
      ));
}
