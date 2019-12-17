import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/book_detail_screen.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/book_add.dart';
import 'dart:math';


class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
//  Choice(title: 'ログアウト', icon: Icons.exit_to_app),
  Choice(title: 'About Us', icon: Icons.people),
];

class OtheruserBooklistScreen extends StatefulWidget {
  final int id;
  final String userName;

  OtheruserBooklistScreen({@required this.id, @required this.userName});

  @override
  OtheruserBooklistScreenState createState() {
    return new OtheruserBooklistScreenState(id: id, userName: userName);
  }
}

class OtheruserBooklistScreenState extends State<OtheruserBooklistScreen> {
  final int id;
  final String userName;

  List<Image> googleImages = [];
  List<Book> serverResponse = [];
  static const Alignment my_bottomRight = Alignment(0.9, 0.9);

  OtheruserBooklistScreenState({@required this.id, @required this.userName});

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
        title:  Text( userName + "の本棚"),    //userNameを入れたい
//        actions: <Widget>[
//          new IconButton(icon: new Icon(Icons.public),
//            onPressed: (){
//              Navigator.of(context).pop('5678');
//            },
//          ),
//          // overflow menux
//          PopupMenuButton<Choice>(
//            // onSelected: _select,
//            itemBuilder: (BuildContext context) {
//              return choices.map((Choice choice) {
//                return PopupMenuItem<Choice>(
//                  value: choice,
//                  child: Text(choice.title),
//                );
//              }).toList();
//            },
//          ),
//        ],

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
    );
  }
  makeGetRequest() async {
    var client = new BookClient();
    List<Book> response = await client.getUserBooks(id);
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

Card StructuredGridCell(BuildContext context, String title, int ISBN, Image image) {
  Icon _icon = Icon(Icons.library_add);
  final Size size = MediaQuery.of(context).size;
  var client = new BookClient();

  return new Card(
      elevation: 1.5,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
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
                      var bookDetailToAdd = new BookDetailToAdd(title: title, ISBN: ISBN.toString(), description: "a");
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
                          //builder: (context) => ThreadList(),
                            builder: (context) => DetailScreen(
                                bookTitle: title, bookISBN: ISBN)),
                      );
                    },
                  ),
                ),
                new Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: size.height * 0.017),
                ),
              ],
            ),
          )
        ],
      ));
}
