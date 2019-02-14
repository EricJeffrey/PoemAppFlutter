import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/ui/my_app.dart';
import 'package:poem_random/ui/poem_place.dart';

class FavorListPage extends StatefulWidget {
  final List<Poem> poems;

  FavorListPage(this.poems);

  @override
  State<StatefulWidget> createState() {
    return FavorListState(poems);
  }
}

class FavorListState extends State<FavorListPage> {
  List<Poem> poems;

  FavorListState(this.poems);

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    Color textColor = MyAppState.settingItem.cText;
    if (poems == null)
      bodyWidget = Center(
        child: Text(
          "出错了",
          style: TextStyle(color: textColor),
        ),
      );
    else {
      List<ListTile> favorListTiles = [];
      for (var item in poems) {
        favorListTiles.add(ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          title: Text(
            item.title,
            style: TextStyle(fontSize: MyAppState.settingItem.fSPoemTitle, color: textColor),
          ),
          subtitle: Text(
            "${item.author} ${item.authorDynasty}",
            style: TextStyle(
              fontSize: MyAppState.settingItem.fSPoemAuthor,
              fontStyle: FontStyle.italic,
              color: textColor,
            ),
          ),
          leading: Icon(Icons.format_align_left, color: MyAppState.settingItem.cIcon),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: MyAppState.settingItem.bgcCommon,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: MyAppState.settingItem.cText),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      body: PoemPlaceStateless(item, topMarginLarge: true),
                      backgroundColor: MyAppState.settingItem.bgcCommon,
                    ),
              ),
            );
          },
        ));
      }
      bodyWidget = ListView(children: favorListTiles);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        toolbarOpacity: 1,
        backgroundColor: MyAppState.settingItem.bgcAppBar,
        elevation: 3,
        titleSpacing: 0,
      ),
      body: bodyWidget,
      backgroundColor: MyAppState.settingItem.bgcCommon,
    );
  }
}
