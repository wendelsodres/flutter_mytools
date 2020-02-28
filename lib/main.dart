import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mytools/convert_currency.dart';
import 'package:mytools/search_gif.dart';
import 'package:mytools/todo.dart';

void main() => runApp(Mytools());

class Mytools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red, hintColor: Colors.red),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mytools'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Wendel Sodré'),
              accountEmail: Text('wendelsodres@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Text('W'),
              ),
            ),
            ListTile(
              title: Text('Todo List'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TodoList()));
              },
            ),
            ListTile(
              title: Text('Convert Currency'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ConvertCurrency()));
              },
            ),
             ListTile(
              title: Text('Favorites Products'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BuscadorGif()));
              },
            ),
            ListTile(
              title: Text('Contacts'),
              onTap: () {
                /* Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BuscadorGif())); */
              },
            ),
            Divider(),
            ListTile(
              title: Text('Exit'),
              trailing: Icon(Icons.exit_to_app),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
