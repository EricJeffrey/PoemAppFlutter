import 'package:path/path.dart';
import 'package:poem_random/data_control/data_model.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = "poem_random.db";

class FavorPoemProvider {
  /// Specific column name
  static const String col_diffDay = "diffDay", col_title = "title", col_author = "author";
  static const String col_authorDynasty = "authorDynasty", col_lines = "paragraphs";
  static const String tableFavor = "favor";
  static const String SQL_CREATE_TABLE = "CREATE TABLE $tableFavor "
      "($col_diffDay INTEGER PRIMARY KEY, $col_title TEXT, $col_author TEXT, $col_authorDynasty TEXT, $col_lines TEXT)";

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
