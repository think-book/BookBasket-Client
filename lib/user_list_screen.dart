import 'package:flutter/material.dart';
import 'package:bookbasket/api/client.dart';

//　次のページ
import 'package:bookbasket/otheruser_booklist_screen.dart';

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
//  Choice(title: 'ログアウト', icon: Icons.exit_to_app),
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
    final Size size = MediaQuery.of(context).size;
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
//            margin: EdgeInsets.symmetric(horizontal: (size.width ) / 10),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
//              child: new ListView.builder(
//                  itemCount: serverResponse.length,
//                  itemBuilder: (context,index){
//                    return StructuredListCell(context, serverResponse[index].id, serverResponse[index].userName);
//                  }
//              ),
              child: new GridView.count(
                shrinkWrap: true,
                childAspectRatio: 4,
                mainAxisSpacing: 0,
//                crossAxisSpacing: 10,
                crossAxisCount: (size.width * 1.3  < size.height ) ? 1 : size.width~/350,
                children: List.generate(serverResponse.length, (index) {
                  return StructuredListCell(context, serverResponse[index].id,
                      serverResponse[index].userName);
                }),
              ),
            ),
          )
        ],
      ),

      backgroundColor: Colors.white,
    );
  }
  makeGetRequest() async {
    var client = new BookClient();
    List<User> response = (await client.getUsers()).cast<User>();
    setState(() {
      serverResponse = response;
    });
  }
}

Container StructuredListCell(BuildContext context, int id, String userName){
  return Container(
    alignment: Alignment.centerLeft,
    child: Card(
      elevation: 1.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: ListTile(
              leading: Icon(Icons.account_circle, size: 40,),
              title: Text(userName),
              subtitle: Text('User'),
            ),
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
        ],
      )
    ) ,
  );
}
