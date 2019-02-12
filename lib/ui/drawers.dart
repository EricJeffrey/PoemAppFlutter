import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_fetcher.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/data_control/favor_poem_provider.dart';
import 'package:poem_random/data_control/setting_providers.dart';
import 'package:poem_random/ui/favor_list.dart';
import 'package:poem_random/ui/my_app.dart';
import 'package:poem_random/ui/setting_btm_sheet.dart';
import 'package:share/share.dart';

const String _githubUrl = "https://github.com/EricJeffrey/PoemAppFlutter";

class LeftDrawer extends StatelessWidget {
  final MyAppState appState;

  const LeftDrawer(this.appState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["我的收藏", "阅读设置", "关于作者"];
    List<IconData> icons = [Icons.bookmark, Icons.settings, Icons.help];
    Function myFavorTapFunc = () {
      FavorPoemProvider favorProvider = FavorPoemProvider.getInstance();
      favorProvider.open().then((tmp) {
        favorProvider.queryAll().then((List<Poem> poems) {
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
    Function settingTapFunc = () {
      Navigator.pop(context);
      showBottomSheet(
        context: context,
        builder: (BuildContext context) => SettingBtmSheet(appState),
      );
    };
    Function thumbUpTapFunc = () {
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Developed by EricJeffrey with Flutter~"),
        duration: Duration(milliseconds: 1500),
      ));

      /// TODO show about or thumb up
    };
    List<Function> funcs = [myFavorTapFunc, settingTapFunc, thumbUpTapFunc];
    List<LeftDrawerTile> tiles = [];
    for (var i = 0; i < titles.length; i++)
      tiles.add(LeftDrawerTile(text: titles[i], iconData: icons[i], onTapFunc: funcs[i]));
    return new Container(
      width: MyAppState.settingItem.leftDrawerWidth,
      color: MyAppState.settingItem.bgcDrawer,
      padding: EdgeInsets.fromLTRB(0, SettingItem.drawerContentTopPad, 0, 0),
      child: new Column(
        children: tiles,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
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
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(iconData, color: Colors.white),
        title: DrawerText(text: text),
        onTap: onTapFunc,
      ),
    );
  }
}

class RightDrawer extends StatefulWidget {
  final MyAppState appState;

  RightDrawer(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RightDrawerState(appState);
  }
}

class _RightDrawerState extends State<RightDrawer> {
  static DateTime cmpDate = DateTime(2019);
  final MyAppState appState;

  _RightDrawerState(this.appState);

  int curDiffDay() {
    int res = DateTime.now().difference(cmpDate).inDays;
    res = 5;
    return res;
  }

  void checkPoemStored(int diffDay, Function(Poem, FavorPoemProvider) callback) {
    FavorPoemProvider poemProvider = FavorPoemProvider.getInstance();
    poemProvider.open().then((tmp) {
      poemProvider.queryFavor(diffDay).then((Poem poem) => callback(poem, poemProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Favor function
    _FavorTileState favorState;
    Function favorFunc = () {
      Navigator.pop(context);
      Poem currentPoem = appState.getCurrentPoem();
      int diffDay = appState.getCurrentPoem().diffDay;
      // check whether this poem has stored
      checkPoemStored(
        diffDay,
        (Poem poem, FavorPoemProvider provider) {
          if (poem == null) {
            provider.insert(currentPoem).then((Poem poem) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("已收藏"),
                duration: Duration(seconds: 2),
              ));
              favorState.update(true);
            });
          } else {
            provider.delete(diffDay).then((v) {
              if (v != null)
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("已取消收藏"),
                  duration: Duration(seconds: 2),
                ));
              favorState.update(false);
            });
          }
        },
      );
    };
    favorState = _FavorTileState(favorFunc, false);

    /// Check whether poem has favored
    checkPoemStored(appState.getCurrentPoem().diffDay, (Poem poem, FavorPoemProvider provider) {
      if (poem == null)
        favorState.update(false);
      else
        favorState.update(true);
    });
    Function shareFunc = () {
      Navigator.pop(context);
      Share.share(_githubUrl);
    };
    Function preFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_pre);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder dataHolder) {
        appState.setPoemPlaceState(dataHolder: dataHolder);
      });
    };
    Function nextFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_nxt);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder dataHolder) {
        appState.setPoemPlaceState(dataHolder: dataHolder);
      });
    };
    Function randFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_rand);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder dataHolder) {
        appState.setPoemPlaceState(dataHolder: dataHolder);
      });
    };
    Function todayFunc = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataOfType(FetchType.type_today);
      Navigator.pop(context);
      tmpFuture.then((NetworkDataHolder dataHolder) {
        appState.setPoemPlaceState(dataHolder: dataHolder);
      });
    };

    List<Function> funcs = [shareFunc, preFunc, randFunc];
    List<String> texts = ["分享", "前一天", "随机"];
    List<IconData> icons = [Icons.share, Icons.fast_rewind, Icons.all_inclusive];

    int curDay = curDiffDay(), poemDay = appState.getCurrentPoem().diffDay;
    if (poemDay != curDay) {
      funcs.insert(2, nextFunc);
      funcs.add(todayFunc);
      texts.insert(2, "后一天");
      texts.add("今日");
      icons.insert(2, Icons.fast_forward);
      icons.add(Icons.access_time);
    }

    List<Widget> tiles = [FavorTile(drawerState: favorState)];
    for (var i = 0; i < funcs.length; i++) {
      tiles.add(RightDrawerTile(texts[i], icons[i], funcs[i]));
    }
    return Container(
      width: MyAppState.settingItem.rightDrawerWidth,
      color: MyAppState.settingItem.bgcDrawer,
      padding: EdgeInsets.fromLTRB(0, SettingItem.drawerContentTopPad, 0, 0),
      child: Column(children: tiles),
    );
  }
}

/// Favor widget
class FavorTile extends StatefulWidget {
  final _FavorTileState drawerState;

  const FavorTile({Key key, this.drawerState}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return drawerState;
  }
}

class _FavorTileState extends State<StatefulWidget> {
  final Function onPressFunc;
  bool poemStored;

  _FavorTileState(this.onPressFunc, this.poemStored);

  void update(bool ps) {
    setState(() => poemStored = ps);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    String text = "收藏";
    if (poemStored) {
      color = Colors.redAccent;
      text = "已收藏";
    }
    return RightDrawerTile(text, Icons.favorite, onPressFunc, iconColor: color);
  }
}

class RightDrawerTile extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function onPressFunc;
  final Color iconColor;

  const RightDrawerTile(this.text, this.iconData, this.onPressFunc,
      {Key key, this.iconColor: Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 400,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
          onTap: onPressFunc,
          splashColor: Colors.grey,
          child: Column(
            children: <Widget>[Icon(iconData, color: iconColor), DrawerText(text: text)],
          ),
        ),
      ),
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
        fontSize: MyAppState.settingItem.fSCommon,
        color: Colors.white,
      ),
    );
  }
}
