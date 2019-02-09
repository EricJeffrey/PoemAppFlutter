import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_fetcher.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/data_control/db_manip.dart';
import 'package:poem_random/ui/favor_list.dart';
import 'package:poem_random/ui/poem_place.dart';

class LeftDrawer extends StatelessWidget {
  final double width;

  const LeftDrawer({Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["我的收藏", "阅读设置", "给个好评"];
    List<IconData> icons = [Icons.bookmark, Icons.settings, Icons.thumb_up];
    Function myFavorTapFunc = () {
      FavorPoemProvider favorProvider = FavorPoemProvider.getInstance();
      favorProvider.open().then((tmp) {
        favorProvider.getAllFavorPoem().then((List<Poem> poems) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FavorListPage(poems),
            ),
          );
        });
      });
    };

    /// TODO setting page
    Function settingTapFunc = () {};

    /// TODO thumbUp page
    Function thumbUpTapFunc = () {};
    List<Function> funcs = [myFavorTapFunc, settingTapFunc, thumbUpTapFunc];
    List<LeftDrawerTile> tiles = [];
    for (var i = 0; i < titles.length; i++) {
      tiles.add(LeftDrawerTile(
        text: titles[i],
        iconData: icons[i],
        onTapFunc: funcs[i],
      ));
    }
    return new Container(
      child: new Column(children: tiles),
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

  /// State of [DataHolderStateful] in Home page, used to notify in tap event
  final DataHolderState state;

  RightDrawer(this.state, {this.width = 150, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> texts = ["收藏", "分享", "前一天", "后一天", "随机", "今日"];
    List<IconData> icons = [
      Icons.favorite,
      Icons.share,
      Icons.fast_rewind,
      Icons.fast_forward,
      Icons.all_inclusive,
      Icons.access_time,
    ];
    Function favorFunc = () {
      FavorPoemProvider provider = FavorPoemProvider.getInstance();
      Navigator.pop(context);
      int diffDay = state.dataHolder.poem.diffDay;
      provider.open().then((tmp) {
        provider.getPoem(diffDay).then((Poem poem) {
          if (poem == null)
            provider.insert(state.dataHolder.poem).then((Poem poem) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("已收藏"),
                duration: Duration(seconds: 2),
              ));
            });
          else
            provider.delete(diffDay).then((v) {
              if (v != null)
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("已取消收藏"),
                  duration: Duration(seconds: 2),
                ));
            });
        });
      });
    };
    Function shareFunc = () {
      /// TODO share
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("正在开发中")));
    };
    Function preFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_pre);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder data) {
        state.setMyState(data);
      });
    };
    Function nextFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_nxt);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder data) {
        state.setMyState(data);
      });
    };
    Function randFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_rand);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder data) {
        state.setMyState(data);
      });
    };
    Function todayFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_today);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder data) {
        state.setMyState(data);
      });
    };
    List<Function> funcs = [favorFunc, shareFunc, preFunc, nextFunc, randFunc, todayFunc];
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
