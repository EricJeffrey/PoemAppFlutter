import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/ui/drawers.dart';
import 'package:poem_random/ui/poem_place.dart';
import 'package:poem_random/data_control/data_fetcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataHolderState state = DataHolderState();
    Function func = () {
      Future<NetworkDataHolder> tmpFuture = fetchDataRandom();
      tmpFuture.then((NetworkDataHolder dataHolder) {
        state.setStateByType(dataHolder, DataHolderState.type_next);
      });
    };
    // TODO add event listener
    // List<Function> funcs = [() {}];
    return Scaffold(
      body: DataHolderStateful(state),
      drawer: LeftDrawer(width: 200),
      endDrawer: RightDrawer(func, width: 200),
    );
  }
}
