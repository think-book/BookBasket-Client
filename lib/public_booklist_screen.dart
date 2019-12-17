import 'package:bookbasket/book_add.dart';
import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/book_detail_screen.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'dart:math';

class PublicBook {
  final String title;
  final int ISBN;

  PublicBook({
    this.title,
    this.ISBN,
  });

  factory PublicBook.fromJson(Map<String, dynamic> json) {
    return new PublicBook(
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

class PublicBookListScreen extends StatefulWidget {
  @override
  PublicBookListScreenState createState() {
    return new PublicBookListScreenState();
  }
}

class PublicBookListScreenState extends State<PublicBookListScreen> {
  List<PublicBook> serverResponse = [];
  List<Image> googleImages = [];
  static const Alignment my_bottomRight = Alignment(0.9, 0.9);
  // Icon _icon = Icon(Icons.library_add);
  // var client = new BookClient();

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
        title: const Text('みんなの本棚'),
        automaticallyImplyLeading: false, // appBarのback buttonを隠す
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.account_box),
              onPressed: (){
                Navigator.of(context).pop('1234');
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
//            margin: EdgeInsets.symmetric(horizontal: (size.width < size.height ) ? 0 : (size.width - size.height) / 5),
//            margin: EdgeInsets.symmetric(horizontal: (size.width % 200) / 10),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: new GridView.count(
                shrinkWrap: true,
//                crossAxisCount: (size.width~/180), // size of thumbnail is 128x189
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

    );
  }
  makeGetRequest() async {
    var client = new BookClient();
    List<PublicBook> response = await client.getPublicBookList();
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

  Icon _icon = Icon(Icons.library_add);
  var client = new BookClient();
  final Size size = MediaQuery.of(context).size;

  return new Card(
    elevation: 1.5,
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
//      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child:  IconButton(
                  icon: _icon,
                  iconSize: 20,
                  onPressed: () async {
                    var bookDetailToAdd = new BookDetailToAdd(title: bookTitle, ISBN: bookISBN.toString(), description: "a");
                    try{
                      var result = await client.postBook(bookDetailToAdd);
                    }
                    on BookAddException catch(e){
                      print(e.errorMessage());
                      // ここでdialogとか表示したい
                    }
                  },
                ),
              ),
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
    )
  );
}
