import 'package:poem_random/data_control/db_manip.dart';

/// Structure of a Poem, with property:
/// {title, author, authorDynasty, lines}
class Poem {
  static const String SPLIT_STR = "=_=";

  int reserveVal;
  int diffDay;
  String title;
  String author;
  String authorDynasty;
  List<String> lines;

  Poem({this.diffDay, this.title, this.author, this.authorDynasty, this.lines});

  /// Create a Poem from Map returned by json.decode()
  factory Poem.fromJsonMap(Map<String, dynamic> jsonMap) {
    Poem res = Poem(
      diffDay: jsonMap[FavorPoemProvider.col_diffDay],
      title: jsonMap[FavorPoemProvider.col_title],
      author: jsonMap[FavorPoemProvider.col_author],
      authorDynasty: jsonMap[FavorPoemProvider.col_authorDynasty],
      lines: [],
    );
    for (var item in jsonMap[FavorPoemProvider.col_lines]) res.lines.add(item);
    return res;
  }

  /// Create a Poem from Map return from database
  factory Poem.fromDbMap(Map<String, dynamic> dbMap) {
    String linesStr = dbMap[FavorPoemProvider.col_lines];
    Poem res = Poem(
      diffDay: dbMap[FavorPoemProvider.col_diffDay],
      title: dbMap[FavorPoemProvider.col_title],
      author: dbMap[FavorPoemProvider.col_author],
      authorDynasty: dbMap[FavorPoemProvider.col_authorDynasty],
      lines: linesStr.split(SPLIT_STR),
    );
    return res;
  }

  /// Convert this Poem Data into a Map
  Map<String, dynamic> toMap() {
    String linesStr = "";
    for (var i = 0; i < lines.length; i++) {
      if (i > 0) linesStr += SPLIT_STR;
      linesStr += lines[i];
    }
    Map<String, dynamic> resMap = {
      FavorPoemProvider.col_diffDay: diffDay,
      FavorPoemProvider.col_title: title,
      FavorPoemProvider.col_author: author,
      FavorPoemProvider.col_authorDynasty: authorDynasty,
      FavorPoemProvider.col_lines: linesStr
    };
    return resMap;
  }

  bool isPoemValid() {
    if (diffDay == null ||
        title == null ||
        author == null ||
        authorDynasty == null ||
        lines == null) return false;
    return true;
  }
}

/// A data holder that contains both transferred data and data info from Internet,
/// with property {poem, dataFetched, errorOccurred, errorInfo}
class NetworkDataHolder {
  Poem poem;
  bool dataFetched;
  bool errorOccurred;
  Object errorInfo;

  NetworkDataHolder({this.errorOccurred = false, this.poem, this.errorInfo}) {
    if (errorOccurred) {
      dataFetched = false;
      poem = null;
    }
    if (poem != null && poem.isPoemValid())
      dataFetched = true;
    else
      dataFetched = false;
  }
}
