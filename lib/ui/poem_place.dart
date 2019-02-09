import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_fetcher.dart';
import 'package:poem_random/data_control/data_model.dart';

/// Place to show current network status
class DataHolderStateful extends StatefulWidget {
  final DataHolderState state;

  DataHolderStateful(this.state, {Key key}) : super(key: key);

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
    if (dataHolder == null) return Center(child: CircularProgressIndicator());
    if (dataHolder.errorOccurred) return Center(child: Text(dataHolder.errorInfo.toString()));
    if (!dataHolder.dataFetched) return Center(child: Text("No data found"));
    return PoemPlaceStateless(dataHolder.poem);
  }
}

/// Place to show the poem fetched
class PoemPlaceStateless extends StatelessWidget {
  final Poem poem;

  PoemPlaceStateless(this.poem, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle authorStyle = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);
    const TextStyle linesStyle = TextStyle(fontSize: 18);

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
          color: Colors.yellow[50],
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
