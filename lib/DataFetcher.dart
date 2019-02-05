import 'package:dio/dio.dart';
class Poem {
  String title, author, authorDynasty;
  List<String> lines;
  Poem({this.title, this.author, this.authorDynasty, this.lines});
}

class DataFetcher {
  void getToday() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("localhost:8000/");
    return print(response);
  }
}
