import 'package:flutter/material.dart';
import 'package:poem_random/data_control/my_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeType { common, title, subTitle, poemTitle, poemAuthor, poemLines }

class SettingItem {
  // Four kind poem background color setting
  static const Color whiteSmoke = Color(0xFFF5F5F5);
  static const List<Color> pPBgColors = [
    whiteSmoke,
    Color(0xFFB3E5FC),
    Color(0xFFFFECB3),
    Color(0xFFB2EBF2)
  ];
  static const List<int> pPBgColorCode = [1, 2, 3, 4];
  static const Color bgcNightMode = Color(0xFF212121);

  // All kinds of FontSize
  static const double fSIncrement = 2;
  static const double fSCommonInit = 14;
  static const double fSTitleInit = 18;
  static const double fSSubTitleInit = 16;
  static const double fSPoemTitleInit = 18;
  static const double fSPoemAuthorInit = 14;
  static const double fSPoemLinesInit = 16;
  static const List<int> fSCommonCode = [-1, 0, 1];
  static const List<String> fSCommonDesc = ['小', '中', '大'];
  static List<double> fSList(FontSizeType type) {
    List<double> res = [];
    double fs;
    switch (type) {
      case FontSizeType.common:
        fs = fSCommonInit;
        break;
      case FontSizeType.title:
        fs = fSTitleInit;
        break;
      case FontSizeType.subTitle:
        fs = fSSubTitleInit;
        break;
      case FontSizeType.poemTitle:
        fs = fSPoemTitleInit;
        break;
      case FontSizeType.poemAuthor:
        fs = fSPoemAuthorInit;
        break;
      case FontSizeType.poemLines:
        fs = fSPoemLinesInit;
        break;
    }
    for (int i = 0; i < fSCommonCode.length; i++) res.add(fs + i * fSIncrement);
    return res;
  }

  // String used as key
  static const String key_font_size = "font_size";
  static const String key_bg_color = "bg_color";
  static const String key_night_mode = "night_mode";

  // Drawer width
  static const int drawerWidthInc = 10;
  static double leftDrawerWidthInit = 160;
  static double rightDrawerWidthInit = 80;
  static double drawerContentTopPad = 50;

  // Current user setting
  int fontSizeCode;
  int poemPlaceBgColorCode;
  bool nightModeOn;

  /// Generated real font size setting
  // font size
  double fSCommon;
  double fSTitle;
  double fSSubTitle;
  double fSPoemTitle;
  double fSPoemAuthor;
  double fSPoemLines;
  // drawer width
  double leftDrawerWidth;
  double rightDrawerWidth;
  // Text, icon and background color
  Color cText = Colors.black;
  Color bgcPoemPlace = Colors.white70;
  Color bgcCommon = whiteSmoke;
  Color bgcAppBar = Colors.blueAccent;
  Color cIcon = Colors.grey;
  Color bgcDrawer = bgcNightMode;
  Color bgcBottomSheet = Colors.grey[350];

  SettingItem(this.fontSizeCode, this.poemPlaceBgColorCode, this.nightModeOn) {
    _calculateFsAndDrawerWidth();
    _calculateColor();
  }

  /// Get font size and drawer width
  void _calculateFsAndDrawerWidth() {
    int index = 0;
    for (var i = 0; i < fSCommonCode.length; i++) if (fSCommonCode[i] == fontSizeCode) index = i;
    fSCommon = fSList(FontSizeType.common)[index];
    fSTitle = fSList(FontSizeType.title)[index];
    fSSubTitle = fSList(FontSizeType.subTitle)[index];
    fSPoemTitle = fSList(FontSizeType.poemTitle)[index];
    fSPoemAuthor = fSList(FontSizeType.poemAuthor)[index];
    fSPoemLines = fSList(FontSizeType.poemLines)[index];
    leftDrawerWidth = leftDrawerWidthInit + drawerWidthInc * index;
    rightDrawerWidth = rightDrawerWidthInit + drawerWidthInc * index;
  }

  /// Get colors
  void _calculateColor() {
    if (nightModeOn) {
      cText = cIcon = Colors.white;
      bgcPoemPlace = bgcCommon = bgcAppBar = bgcNightMode;
      bgcBottomSheet = Colors.grey[850];
    } else {
      bgcBottomSheet = Colors.grey[300];
      cText = Colors.black;
      cIcon = Colors.grey;
      bgcCommon = whiteSmoke;
      bgcAppBar = Colors.blueAccent;
      int index = 0;
      for (var i = 0; i < pPBgColorCode.length; i++)
        if (poemPlaceBgColorCode == pPBgColorCode[i]) index = i;
      bgcPoemPlace = pPBgColors[index];
    }
  }

  /// Update user setting
  void update({int fSCode, int pPBgCCode, bool nmo}) {
    if (fSCode != null && fSCode != fontSizeCode) fontSizeCode = fSCode;
    if (pPBgCCode != null && pPBgCCode != poemPlaceBgColorCode) poemPlaceBgColorCode = pPBgCCode;
    if (nmo != null && nmo != nightModeOn) nightModeOn = nmo;
    _calculateFsAndDrawerWidth();
    _calculateColor();
  }
}

class SettingItemProvider {
  static SettingItemProvider provider;

  static SettingItemProvider getInstance() {
    if (provider == null) provider = SettingItemProvider();
    return provider;
  }

  Future saveSettings(SettingItem settingItem) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setInt(SettingItem.key_font_size, settingItem.fontSizeCode);
    preference.setInt(SettingItem.key_bg_color, settingItem.poemPlaceBgColorCode);
    preference.setBool(SettingItem.key_night_mode, settingItem.nightModeOn);
  }

  /// Check whether setting info has stored in shared_preference
  Future<bool> isSettingStored() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    if (preference.getKeys().length <= 0) return false;
    return true;
  }

  /// Get setting stored in SharedPreference,
  /// use [isSettingStored] to check whether setting is avaliable or not
  Future<SettingItem> readSettings() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    int fs = preference.getInt(SettingItem.key_font_size);
    int bgc = preference.getInt(SettingItem.key_bg_color);
    bool nm = preference.getBool(SettingItem.key_night_mode);
    return SettingItem(fs, bgc, nm);
  }
}
