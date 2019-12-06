import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/user_list_screen.dart';
import 'package:bookbasket/book_detail_screen.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/book_add.dart';

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'ログアウト', icon: Icons.exit_to_app),
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
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: new GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(serverResponse.length, (index) {
                return StructuredGridCell(context, serverResponse[index].title,
                    serverResponse[index].ISBN);
              }),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.white,
//      floatingActionButton: FloatingActionButton(
//        onPressed: () => {
//        Navigator.of(context)
//            .push(new MaterialPageRoute<String>(
//          builder: (context) => BookAddScreen(),
//        ))
//            .then((String value) {
//          if (value == 'magic') {
//            setState(() {
//              initState();
//            });
//          }
//        }),
//        },
//        tooltip: 'Add a neww book',
//        backgroundColor: Color(0xff9b5acf),
//        child: const Icon(Icons.add_box),
//      ),
    );
  }
  makeGetRequest() async {
    var client = new BookClient();
    List<Book> response = await client.getUserBooks(id);
    setState(() {
      serverResponse = response;
    });
  }
}

Card StructuredGridCell(BuildContext context, String title, int ISBN) {
  Icon _icon = Icon(Icons.library_add);
  var client = new BookClient();

  return new Card(
      elevation: 1.5,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: (Image.asset('res/img/book.png')),
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
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      new Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      new IconButton(
                        icon: _icon,
                        onPressed: () async {
                          if (_icon == Icon(Icons.done)){
                            return;
                          }
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
                    ]
                ),
              ],
            ),
          )
        ],
      ));
}
