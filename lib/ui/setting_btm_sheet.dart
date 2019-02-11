import 'package:flutter/material.dart';
import 'package:poem_random/data_control/setting_providers.dart';
import 'package:poem_random/ui/my_app.dart';

class SettingBtmSheet extends StatefulWidget {
  final MyAppState appState;

  const SettingBtmSheet(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingBtmState(appState);
  }
}

class SettingBtmState extends State<SettingBtmSheet> {
  final MyAppState appState;

  SettingBtmState(this.appState);

  void setMyState({void Function() callBack}) {
    if (callBack != null)
      setState(callBack);
    else
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int groupValIndex = 0;
    List<int> vals = SettingItem.pPBgColorCode;
    for (int i = 0; i < vals.length; i++)
      if (vals[i] == MyAppState.settingItem.poemPlaceBgColorCode) groupValIndex = i;
    List<Widget> bgWidgets = [new LabelText(text: '背景')];
    List<String> bgTitles = ['白', '蓝', '黄', '青'];
    for (var i = 0; i < vals.length; i++) {
      bgWidgets.add(TextRadio(
        TextStyle(fontSize: MyAppState.settingItem.fSCommon, color: MyAppState.settingItem.cText),
        bgTitles[i],
        vals[i],
        vals[groupValIndex],
        (int s) {
          appState.updateSetting(pPBgCCode: vals[i]);
          setState(() {});
        },
      ));
    }
    Widget settingColumn = Column(
      children: <Widget>[
        Row(children: <Widget>[new LabelText(text: "字号"), SettingFSWidget(appState, this)]),
        Row(children: bgWidgets),
        Row(children: <Widget>[
          new LabelText(text: "夜间"),
          MySwitch(
            MyAppState.settingItem.nightModeOn,
            (bool value) {
              appState.updateSetting(nmo: value);
              setState(() {});
            },
          )
        ])
      ],
    );
    return Container(
      height: 180,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: MyAppState.settingItem.bgcBottomSheet,
      child: settingColumn,
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;

  const LabelText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: MyAppState.settingItem.cText,
        fontSize: MyAppState.settingItem.fSCommon,
      ),
    );
  }
}

class MySwitch extends StatefulWidget {
  final void Function(bool) onChanged;
  final bool value;

  const MySwitch(this.value, this.onChanged, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MySwitchState(value, onChanged);
  }
}

class MySwitchState extends State<MySwitch> {
  void Function(bool) onChanged;
  bool value;

  MySwitchState(this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (bool val) {
        setState(() => value = val);
        onChanged(val);
      },
      value: value,
    );
  }
}

/// Font size setting row
class SettingFSWidget extends StatefulWidget {
  final MyAppState appState;
  final SettingBtmState btmSheetState;

  const SettingFSWidget(this.appState, this.btmSheetState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingFSState(appState, btmSheetState);
  }
}

/// Font size setting row state
class _SettingFSState extends State<SettingFSWidget> {
  final MyAppState appState;
  final SettingBtmState btmSheetState;

  _SettingFSState(this.appState, this.btmSheetState);

  @override
  Widget build(BuildContext context) {
    List<String> titles = SettingItem.fSCommonDesc;
    List<int> vals = SettingItem.fSCommonCode;
    int groupValIndex = 0;
    for (int i = 0; i < vals.length; i++)
      if (vals[i] == MyAppState.settingItem.fontSizeCode) groupValIndex = i;
    Color textColor = MyAppState.settingItem.cText;
    List<double> fontSizeCommon = SettingItem.fSList(FontSizeType.common);
    List<Widget> widgets = [];
    for (var i = 0; i < titles.length; i++) {
      Widget tmp = TextRadio(
        TextStyle(fontSize: fontSizeCommon[i], color: textColor),
        titles[i],
        vals[i],
        vals[groupValIndex],
        (int v) {
          appState.updateSetting(fSCode: vals[i]);
          setState(() {});
          btmSheetState.setMyState();
        },
      );
      widgets.add(tmp);
    }
    return Row(children: widgets);
  }
}

class TextRadio extends StatelessWidget {
  final TextStyle textStyle;
  final String title;
  final int groupVal;
  final int val;
  final void Function(int val) onChanged;

  const TextRadio(this.textStyle, this.title, this.val, this.groupVal, this.onChanged, {Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio<int>(groupValue: groupVal, onChanged: onChanged, value: val),
        Text(title, style: textStyle)
      ],
    );
  }
}
