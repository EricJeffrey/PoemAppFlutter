import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_model.dart';
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
    if (poems == null)
      return Scaffold(
        body: Center(child: Text("出错了")),
      );
    List<ListTile> favorListTiles = [];
    for (var item in poems) {
      favorListTiles.add(ListTile(
        contentPadding: EdgeInsets.all(3),
        title: Text(
          item.title,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          "${item.author} ${item.authorDynasty}",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
    return Scaffold(
      body: ListView(children: favorListTiles),
    );
  }
}
