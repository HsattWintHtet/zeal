import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:funkrafte/data/app_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle ts = TextStyle(color: Colors.white);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(UserData().user.photoUrl)),
              accountName: new Text(
                UserData().user.displayName,
                style: ts,
              ),
              accountEmail: new Text(
                UserData().user.email,
                style: ts,
              ),
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.75), BlendMode.dstATop),
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                        "https://cdn.techjuice.pk/wp-content/uploads/2016/07/31.png"),
                  )),
            ),
          ],
        ),
      ),
      body: Container(),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.create), onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
