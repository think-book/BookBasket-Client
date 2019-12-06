import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/otheruser_booklist_screen.dart';
import 'package:bookbasket/book_add_screen.dart';
import 'package:bookbasket/public_booklist_screen.dart';

class User {
  final int id;
  final String userName;

  User({
    this.id,
    this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['id'],
      userName: json['userName'],
    );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'ログアウト', icon: Icons.exit_to_app),
  Choice(title: 'About Us', icon: Icons.people),
];

class UserListScreen extends StatefulWidget {
  @override
  UserListScreenState createState() {
    return new UserListScreenState();
  }
}

class UserListScreenState extends State<UserListScreen> {
  List<User> serverResponse = [];
  static const Alignment my_bottomRight = Alignment(0.9, 0.9);

  @override
  void initState() {
    makeGetRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザ一覧'),    //userNameを入れたい
        automaticallyImplyLeading: false, // appBarのback buttonを隠す
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.account_box),
              onPressed: (){
                Navigator.of(context).pop('5678');
              },
          ),
          // overflow menux
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
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: new GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(serverResponse.length, (index) {
                return StructuredGridCell(context, serverResponse[index].id,
                    serverResponse[index].userName);
              }),
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
        tooltip: 'Add a neww book',
        backgroundColor: Color(0xff9b5acf),
        child: const Icon(Icons.add_box),
      ),
    );
  }
  makeGetRequest() async {
    var client = new BookClient();
    List<User> response = await client.getUsers();
    setState(() {
      serverResponse = response;
    });
  }
}

Card StructuredGridCell(BuildContext context, int id, String userName) {
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
                  child: (new Icon(Icons.person)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => ThreadList(),
                          builder: (context) => OtheruserBooklistScreen(
                              id: id, userName: userName)),
                    );
                  },
                ),
                new Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ));
}
