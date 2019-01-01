import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funkrafte/data/post.dart';
import 'package:funkrafte/ui/comments.dart';

class PostWidget extends StatelessWidget {
  final Post p;

  PostWidget({@required this.p});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserInfoRow(id: p.uid),
          SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: CachedNetworkImage(
                        imageUrl: p.imageUrl, fit: BoxFit.cover))
                //child: Image.asset('assets/logo.png', fit: BoxFit.cover))
              ],
            ),
          ),
          PostInfoBar(p),
        ],
      ),
    );
  }
}

class UserInfoRow extends StatefulWidget {
  final String id;
  UserInfoRow({this.id});

  @override
  UserInfoRowState createState() {
    return new UserInfoRowState();
  }
}

class UserInfoRowState extends State<UserInfoRow> {
  String imageUrl;
  String userName = "";

  Future<void> _getUserName() async {
    var name = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.id)
        .getDocuments()
        .then((result) => result.documents.elementAt(0)['name']);
    try {
      if (this.mounted)
        setState(() {
          userName = name;
        });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getUserImageUrl() async {
    var url = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.id)
        .getDocuments()
        .then((result) => result.documents.elementAt(0)['photoUrl']);
    try {
      if (this.mounted)
        setState(() {
          imageUrl = url;
        });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUserImageUrl();
    _getUserName();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          imageUrl == null
              ? CircularProgressIndicator()
              : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(imageUrl)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class PostInfoBar extends StatefulWidget {
  final Post p;
  PostInfoBar(this.p);

  @override
  PostInfoBarState createState() {
    return new PostInfoBarState();
  }
}

class PostInfoBarState extends State<PostInfoBar> {
  bool like = false;

  @override
  Widget build(BuildContext context) {
    like = widget.p.liked;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => setState(() => widget.p.like()),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                  child: like
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => Comments(p: widget.p))),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                  child: Icon(Icons.comment),
                ),
              ),
            ],
          ),
          LikesAndCaption(p: widget.p),
        ],
      ),
    );
  }
}

class LikesAndCaption extends StatefulWidget {
  final Post p;

  LikesAndCaption({this.p});
  @override
  _LikesAndCaptionState createState() => _LikesAndCaptionState();
}

class _LikesAndCaptionState extends State<LikesAndCaption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0, bottom: 8.0),
          child: Text(
            widget.p.likes == 1 ? "1 like" : "${widget.p.likes} likes",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.5),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0, right: 16.0, left: 16.0),
          child: Text(widget.p.caption),
        ),
      ],
    );
  }
}
