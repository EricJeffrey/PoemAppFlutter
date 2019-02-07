/// Structure of a Poem, with property:
/// {title, author, authorDynasty, lines}
class Poem {
  String title, author, authorDynasty;
  List<String> lines;

  Poem({this.title, this.author, this.authorDynasty, this.lines});

  /// create a Poem from Map returned by json.decode()
  factory Poem.fromJsonMap(Map<String, dynamic> json) {
    Poem res = Poem(
      title: json['title'],
      author: json['author'],
      authorDynasty: json['authorDynasty'],
      lines: [],
    );
    for (var item in json['lines']) res.lines.add(item);
    return res;
  }

  bool isPoemValid() {
    if (title == null || author == null || authorDynasty == null || lines == null) return false;
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
