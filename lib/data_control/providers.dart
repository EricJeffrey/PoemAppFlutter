import 'package:path/path.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String dbName = "poem_random.db";

class FavorPoemProvider {
  /// Specific column name
  static const String col_diffDay = "diffDay", col_title = "title", col_author = "author";
  static const String col_authorDynasty = "authorDynasty", col_lines = "lines";
  static const String tableFavor = "favor";
  static const String SQL_CREATE_TABLE = "CREATE TABLE $tableFavor "
      "(diffDay INTEGER PRIMARY KEY, title TEXT, author TEXT, authorDynasty TEXT, lines TEXT)";

  Database db;

  static FavorPoemProvider poemProvider;

  static FavorPoemProvider getInstance() {
    if (poemProvider == null) poemProvider = FavorPoemProvider();
    return poemProvider;
  }

  /// Open database [dbName]
  Future open() async {
    String path = join(await getDatabasesPath(), dbName);
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int ver) async {
        await db.execute(SQL_CREATE_TABLE);
      },
    );
    return 0;
  }

  /// Insert a Poem object into database, return a poem with [poem.reserveVal] set to be the diffDay
  Future<Poem> insert(Poem poem) async {
    poem.reserveVal = await db.insert(tableFavor, poem.toMap());
    return poem;
  }

  /// Get poem whose diffDay = [diffDay]
  Future<Poem> queryFavor(int diffDay) async {
    List<Map> maps = await db.query(
      tableFavor,
      columns: [
        col_diffDay,
        col_title,
        col_author,
        col_authorDynasty,
        col_lines,
      ],
      where: '$col_diffDay = ?',
      whereArgs: [diffDay],
    );
    if (maps.length > 0) return Poem.fromDbMap(maps.first);
    return null;
  }

  /// Get all data in favor table
  Future<List<Poem>> queryAll() async {
    List<Map> maps = await db.query(
      tableFavor,
      columns: [
        col_diffDay,
        col_title,
        col_author,
        col_authorDynasty,
        col_lines,
      ],
      orderBy: col_diffDay,
    );
    List<Poem> res = [];
    for (var item in maps) res.add(Poem.fromDbMap(item));
    return res;
  }

  /// Delete one record in database
  Future<int> delete(int diffDay) async {
    return await db.delete(tableFavor, where: '$col_diffDay = ?', whereArgs: [diffDay]);
  }
}

class SettingItem {
  static const int fs_small = -1, fs_middle = 0, fs_big = 1;
  static const int bgc_light_blue = 1, bgc_light_cyan = 2, bgc_amber = 3, bgc_white_smoke = 4;
  static const String font_size_str = "font_size",
      bg_color_str = "bg_color",
      night_mode_str = "night_mode";
  int fontSize;
  int poemPlaceBgColor;
  bool nightModeOn;

  SettingItem(this.fontSize, this.poemPlaceBgColor, this.nightModeOn);
}

class SettingItemProvider {
  static SettingItemProvider provider;

  static SettingItemProvider getInstance() {
    if (provider == null) provider = SettingItemProvider();
    return provider;
  }

  Future saveSettings(SettingItem settingItem) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setInt(SettingItem.font_size_str, settingItem.fontSize);
    preference.setInt(SettingItem.bg_color_str, settingItem.poemPlaceBgColor);
    preference.setBool(SettingItem.night_mode_str, settingItem.nightModeOn);
  }

  Future<bool> isSettingStored() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    if (preference.getKeys().length <= 0) return false;
    return true;
  }

  /// Get setting stored in SharedPreference,
  /// use [isSettingStored] to check whether setting is avaliable or not
  Future<SettingItem> readSettings() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    int fs = preference.getInt(SettingItem.font_size_str);
    int bgc = preference.getInt(SettingItem.bg_color_str);
    bool nm = preference.getBool(SettingItem.night_mode_str);
    return SettingItem(fs, bgc, nm);
  }
}
