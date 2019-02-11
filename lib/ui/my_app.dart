import 'package:flutter/material.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/ui/drawers.dart';
import 'package:poem_random/ui/poem_place.dart';
import 'package:poem_random/data_control/providers.dart';
import 'package:poem_random/ui/setting_btm_sheet.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

/// TODO make other widge using below style
class MyAppState extends State<MyApp> {
  static const double fs_increment = 2;
  static const double fs_common_text_small = 14;
  static const double fs_poem_author_small = 14;
  static const Color whiteSmoke = Color.fromARGB(255, 245, 245, 245);
  static Color bgcNightMode = Colors.grey[900];
  static Color cTextNightMode = Colors.white;

  static double fsCommonText = fs_common_text_small;
  static double fsPoemAuthor = fs_poem_author_small;
  static double fsPoemLines = fs_poem_author_small + 2;
  static double fsPoemTitle = fs_poem_author_small + 4;
  static Color cText = Colors.black;
  static Color bgcPoemPlace = Colors.white70;
  static Color bgcCommon = whiteSmoke;
  static Color bgcAppBar = Colors.blueAccent;

  SettingItem settingItem;

  bool _settingPrepared;

  DataHolderStateful dataHolderWidget = DataHolderStateful();

  MyAppState() {
    _settingPrepared = false;
    settingItem = SettingItem(SettingItem.fs_small, SettingItem.bgc_amber, false);
    SettingItemProvider provider = SettingItemProvider.getInstance();
    provider.isSettingStored().then((bool stored) {
      if (stored) {
        provider.readSettings().then((SettingItem settingItem) {
          this.settingItem = settingItem;
          _settingPrepared = true;
          setState(() {});
        });
      } else {
        provider.saveSettings(settingItem);
        _settingPrepared = true;
        setState(() {});
      }
    });
  }

  void _increaseFsBy(double inc) {
    fsCommonText += inc;
    fsPoemAuthor += inc;
    fsPoemLines += inc;
    fsPoemTitle += inc;
  }

  void _initStyle() {
    if (settingItem == null) return;
    switch (settingItem.fontSize) {
      case SettingItem.fs_small:
        _increaseFsBy(0);
        break;
      case SettingItem.fs_middle:
        _increaseFsBy(2);
        break;
      case SettingItem.fs_big:
        _increaseFsBy(4);
        break;
    }
    if (settingItem.nightModeOn) {
      cText = cTextNightMode;
      bgcPoemPlace = bgcCommon = bgcAppBar = bgcNightMode;
    } else {
      cText = Colors.black;
      bgcCommon = whiteSmoke;
      bgcAppBar = Colors.blueAccent;
      switch (settingItem.poemPlaceBgColor) {
        case SettingItem.bgc_light_blue:
          bgcPoemPlace = Colors.blue[100];
          break;
        case SettingItem.bgc_light_cyan:
          bgcPoemPlace = Colors.cyan[100];
          break;
        case SettingItem.bgc_amber:
          bgcPoemPlace = Colors.amber[100];
          break;
        case SettingItem.bgc_white_smoke:
          bgcPoemPlace = whiteSmoke;
          break;
      }
    }
  }

  void updateSetting({int fs, int pPBgC, bool nm}) {
    if (fs != settingItem.fontSize) {
      setState(() => settingItem.fontSize = fs);
    } else if (pPBgC != settingItem.poemPlaceBgColor) {
      setState(() => settingItem.poemPlaceBgColor = pPBgC);
    } else if (nm != settingItem.nightModeOn) {
      setState(() => settingItem.nightModeOn = nm);
    }
  }

  Poem getCurrentPoem() {
    return dataHolderWidget.state.dataHolder.poem;
  }

  void setPoemPlaceState(NetworkDataHolder dataHolder) {
    dataHolderWidget.state.setMyState(dataHolder);
  }

  @override
  Widget build(BuildContext context) {
    if (!_settingPrepared) return Container();
    _initStyle();
    MaterialApp app = MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: Scaffold(
        body: dataHolderWidget,
        drawer: LeftDrawer(this, width: 160),
        endDrawer: RightDrawer(this, width: 100),
      ),
    );
    return app;
  }
}
