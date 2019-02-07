import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  final double width;

  const LeftDrawer({Key key, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          LeftDrawerTile(iconData: Icons.bookmark, text: "我的收藏", onTapFunc: () {}),
          LeftDrawerTile(iconData: Icons.settings, text: "阅读设置", onTapFunc: () {}),
          LeftDrawerTile(iconData: Icons.thumb_up, text: "给个好评", onTapFunc: () {}),
        ],
      ),
      width: width,
      color: Colors.grey[900],
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    );
  }
}

class LeftDrawerTile extends StatelessWidget {
  final String text;
  final Function onTapFunc;
  final IconData iconData;

  LeftDrawerTile({Key key, this.text, this.onTapFunc, this.iconData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: Icon(iconData, color: Colors.white),
          onTap: onTapFunc,
        ),
      ),
      color: Colors.transparent,
    );
  }
}

class RightDrawer extends StatelessWidget {
  final double width;
  final Function rand;

  RightDrawer(this.rand, {this.width = 150, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> texts = ["收藏", "分享", "前一天", "后一天", "随机", "今日"];
    List<IconData> icons = [
      Icons.favorite,
      Icons.share,
      Icons.fast_rewind,
      Icons.fast_forward,
      Icons.shuffle,
      Icons.today,
    ];
    List<Function> funcs = [
      () {},
      () {},
      () {},
      () {},
      rand,
      () {},
    ];
    List<RightDrawerTile> tiles = [];
    for (var i = 0; i < 6; i++) {
      tiles.add(RightDrawerTile(
        text: texts[i],
        iconData: icons[i],
        onPressFunc: funcs[i],
      ));
    }
    return Container(
      width: width,
      color: Colors.grey[900],
      padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
      child: Column(children: tiles),
    );
  }
}

class RightDrawerTile extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function onPressFunc;

  const RightDrawerTile({Key key, this.text, this.iconData, this.onPressFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 400,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
          child: Column(
            children: <Widget>[
              Icon(iconData, color: Colors.white),
              DrawerText(text: text),
            ],
          ),
          onTap: onPressFunc,
          splashColor: Colors.grey,
        ),
      ),
      color: Colors.transparent,
    );
  }
}

class DrawerText extends StatelessWidget {
  final String text;

  const DrawerText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}
