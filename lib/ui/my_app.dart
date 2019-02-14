import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/data_control/my_log.dart';
import 'package:poem_random/data_control/setting_providers.dart';
import 'package:poem_random/ui/drawers.dart';
import 'package:poem_random/ui/poem_place.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  static SettingItem settingItem;
  bool _settingPrepared;

  DataHolderStateful dataHolderWidget;
  LeftDrawer leftDrawer;
  RightDrawer rightDrawer;

  MyAppState() {
    _settingPrepared = false;
    settingItem = SettingItem(SettingItem.fSCommonCode[0], SettingItem.pPBgColorCode[0], false);
    SettingItemProvider provider = SettingItemProvider.getInstance();
    provider.isSettingStored().then((bool stored) {
      if (stored) {
        provider.readSettings().then((SettingItem settingItem) {
          MyAppState.settingItem = settingItem;
          _settingPrepared = true;
          setState(() {});
        });
      } else {
        provider.saveSettings(settingItem).then((v) {
          _settingPrepared = true;
          setState(() {});
        });
      }
    });
    dataHolderWidget = DataHolderStateful();
    leftDrawer = LeftDrawer(this);
    rightDrawer = RightDrawer(this);
  }

  void updateSetting({int fSCode, int pPBgCCode, bool nmo}) {
    settingItem.update(fSCode: fSCode, pPBgCCode: pPBgCCode, nmo: nmo);
    SettingItemProvider.getInstance().saveSettings(settingItem).then((v) {
      setState(() {});
      dataHolderWidget.state.setMyState();
    }, onError: (StackTrace trace) {
      mylog(trace);
    });
  }

  Poem getCurrentPoem() {
    return dataHolderWidget.state.dataHolder.poem;
  }

  void setPoemPlaceState({NetworkDataHolder dataHolder}) {
    if (dataHolder != null)
      dataHolderWidget.state.setMyState(data: dataHolder);
    else
      dataHolderWidget.state.setMyState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_settingPrepared) return Container(child: CircularProgressIndicator());
    MaterialApp app = MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyAppState.settingItem.bgcCommon,
          elevation: 0,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: MyAppState.settingItem.cText),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) => IconButton(
                    icon: Icon(Icons.more_horiz, color: MyAppState.settingItem.cText),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
            ),
          ],
        ),
        body: dataHolderWidget,
        drawer: LeftDrawer(this),
        endDrawer: RightDrawer(this),
        backgroundColor: settingItem.bgcCommon,
      ),
    );
    return app;
  }
}
