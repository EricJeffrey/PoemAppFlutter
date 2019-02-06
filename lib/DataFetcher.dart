import 'package:http/http.dart';
import 'dart:convert';

class Poem {
  String title, author, authorDynasty;
  List<String> lines;
  Poem({this.title, this.author, this.authorDynasty, this.lines});

  factory Poem.fromJson(Map<String, dynamic> json) {
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
    if (title == null ||
        author == null ||
        authorDynasty == null ||
        lines == null) return false;
    return true;
  }

  @override
  String toString() {
    const sp = "---";
    String res = title + sp + author + sp + authorDynasty + sp;
    for (var item in lines) res += item + sp;
    return res;
  }
}

Future<Poem> fetchData() async {
  final Response response = await get("http://192.168.137.1:8000");
  if (response.statusCode == 200) {
    Map<String, dynamic> tmp =
        jsonDecode(Utf8Decoder().convert(response.bodyBytes));
    return Poem.fromJson(tmp);
  } else {
    throw Exception("failed to load data");
  }
}

void mylog(Object s, {String desc}) {
  if (desc == null) desc = "";
  print("\n$desc:<<<<<<<<<<<<<<${s.toString()}>>>>>>>>>>>>>>\n");
}
