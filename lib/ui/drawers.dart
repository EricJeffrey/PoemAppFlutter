import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_fetcher.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/data_control/favor_poem_provider.dart';
import 'package:poem_random/data_control/setting_providers.dart';
import 'package:poem_random/ui/favor_list.dart';
import 'package:poem_random/ui/my_app.dart';
import 'package:poem_random/ui/setting_btm_sheet.dart';

/// TODO right drawer - stateful

class LeftDrawer extends StatelessWidget {
  final MyAppState appState;

  const LeftDrawer(this.appState, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> titles = ["我的收藏", "阅读设置", "给个好评"];
    List<IconData> icons = [Icons.bookmark, Icons.settings, Icons.thumb_up];
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

    /// TODO thumbUp page
    Function thumbUpTapFunc = () {
      Navigator.pop(context);
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

class RightDrawer extends StatelessWidget {
  final MyAppState appState;

  RightDrawer(this.appState, {Key key}) : super(key: key);

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
      Poem currentPoem = appState.getCurrentPoem();
      int diffDay = currentPoem.diffDay;
      provider.open().then((tmp) {
        provider.queryFavor(diffDay).then((Poem poem) {
          if (poem == null)
            provider.insert(currentPoem).then((Poem poem) {
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
      width: MyAppState.settingItem.rightDrawerWidth,
      color: MyAppState.settingItem.bgcDrawer,
      padding: EdgeInsets.fromLTRB(0, SettingItem.drawerContentTopPad, 0, 0),
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
      color: Colors.transparent,
      child: Container(
        width: 400,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
          onTap: onPressFunc,
          splashColor: Colors.grey,
          child: Column(
            children: <Widget>[Icon(iconData, color: Colors.white), DrawerText(text: text)],
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
