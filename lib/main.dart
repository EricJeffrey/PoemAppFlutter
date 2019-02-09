import 'package:flutter/material.dart';
import 'package:poem_random/ui/drawers.dart';
import 'package:poem_random/ui/poem_place.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataHolderState state = DataHolderState();
    MaterialApp app = MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: Scaffold(
        body: DataHolderStateful(state),
        drawer: LeftDrawer(width: 160),
        endDrawer: RightDrawer(state, width: 100),
      ),
    );
    return app;
  }
}
