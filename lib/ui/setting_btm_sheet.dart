import 'package:flutter/material.dart';

class SettingBtmSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingBtmState();
  }
}

class SettingBtmState extends State<SettingBtmSheet> {
  @override
  Widget build(BuildContext context) {
    /// TODO setting bar, using radio and switch

    return Container(child: TestWidget(), height: 200);
  }
}

class TestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestState();
  }
}

class TestState extends State<TestWidget> {
  int groupVal = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Radio<int>(
            groupValue: groupVal,
            onChanged: (int value) => setState(() => groupVal = value),
            value: 1,
          ),
          Text(groupVal.toString())
        ],
      ),
    );
  }
}
