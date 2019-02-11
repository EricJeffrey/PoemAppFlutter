import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_fetcher.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/ui/my_app.dart';

/// Place to show current network status
class DataHolderStateful extends StatefulWidget {
  final DataHolderState state = DataHolderState();

  DataHolderStateful({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

/// State of [DataHolderStateful]
class DataHolderState extends State<DataHolderStateful> {
  /// Contain data from the Internet
  NetworkDataHolder dataHolder;

  @override
  void initState() {
    super.initState();
    Future<NetworkDataHolder> tmpNetwordData = fetchDataOfType(FetchType.type_today);
    tmpNetwordData.timeout(Duration(seconds: 3), onTimeout: () {});
    tmpNetwordData.then((NetworkDataHolder data) {
      setState(() => dataHolder = data);
    });
  }

  /// Set state of this state
  void setMyState(NetworkDataHolder data) {
    setState(() => dataHolder = data);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (dataHolder == null)
      child = Center(child: CircularProgressIndicator());
    else if (dataHolder.errorOccurred)
      child = Center(child: Text(dataHolder.errorInfo.toString()));
    else if (!dataHolder.dataFetched)
      child = Center(child: Text("No data found"));
    else
      child = PoemPlaceStateless(dataHolder.poem);
    return Container(color: MyAppState.bgcCommon, child: child);
  }
}

/// Place to show the poem fetched
class PoemPlaceStateless extends StatelessWidget {
  final Poem poem;

  PoemPlaceStateless(this.poem, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontSize: MyAppState.fsPoemTitle,
      fontWeight: FontWeight.bold,
      color: MyAppState.cText,
    );
    TextStyle authorStyle = TextStyle(
      fontSize: MyAppState.fsPoemAuthor,
      fontStyle: FontStyle.italic,
      color: MyAppState.cText,
    );
    TextStyle linesStyle = TextStyle(
      fontSize: MyAppState.fsPoemLines,
      color: MyAppState.cText,
    );

    Widget titleWidget = Text(poem.title, style: titleStyle);
    Widget authorWidget = Text("${poem.author} ${poem.authorDynasty}", style: authorStyle);
    List<Text> poemWidgets = [titleWidget, authorWidget];
    for (var item in poem.lines) poemWidgets.add(Text(item, style: linesStyle));

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.fromLTRB(10, 40, 10, 20),
        child: Container(
          width: 400,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          color: MyAppState.bgcPoemPlace,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: poemWidgets,
            ),
          ),
        ),
      ),
    );
  }
}
