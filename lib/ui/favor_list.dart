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
    if (poems == null)
      bodyWidget = Center(child: Text("出错了"));
    else {
      List<ListTile> favorListTiles = [];
      for (var item in poems) {
        favorListTiles.add(ListTile(
          contentPadding: EdgeInsets.all(3),
          title: Text(
            item.title,
            style: TextStyle(fontSize: MyAppState.fsPoemTitle),
          ),
          subtitle: Text(
            "${item.author} ${item.authorDynasty}",
            style: TextStyle(fontSize: MyAppState.fsPoemAuthor, fontStyle: FontStyle.italic),
          ),
          leading: Icon(Icons.cached),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Scaffold(body: PoemPlaceStateless(item)),
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
        backgroundColor: MyAppState.bgcAppBar,
        elevation: 3,
        titleSpacing: 0,
      ),
      body: bodyWidget,
    );
  }
}
