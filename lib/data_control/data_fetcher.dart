import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:poem_random/data_control/data_model.dart';
import 'package:poem_random/data_control/favor_poem_provider.dart';

const String HOST = "http://123.206.16.70:8080/";
const String URL_TODAY = HOST + "today";
const String URL_RAND = HOST + "poemrandom";
const String URL_PRE = HOST + "poemofday";
const String URL_NEXT = HOST + "poemofday";

/// Parse a bytes into utf-8 string, then to json, then to Poem
Poem parseJsonBytesData(Uint8List data) {
  String res = Utf8Decoder().convert(data);
  Map<String, dynamic> resMap = jsonDecode(res);
  resMap[FavorPoemProvider.col_lines] = jsonDecode(resMap[FavorPoemProvider.col_lines]);
  return Poem.fromJsonMap(resMap);
}

/// 4 way of fetch data
enum FetchType { type_today, type_rand, type_pre, type_nxt }

/// Fetch data from server, fetch url is set by fetchType.
/// Para [day] is needed when [fetchType] is [FetchType.type_nxt] or [FetchType.type_pre]
Future<NetworkDataHolder> fetchDataOfType(FetchType fetchType, {int day}) async {
  try {
    // sleep(Duration(milliseconds: 200));
    String fetchUrl;

    switch (fetchType) {
      case FetchType.type_today:
        fetchUrl = URL_TODAY;
        break;
      case FetchType.type_pre:
        fetchUrl = URL_PRE + "?diffDay=$day";
        break;
      case FetchType.type_nxt:
        fetchUrl = URL_NEXT + "?diffDay=$day";
        break;
      case FetchType.type_rand:
        fetchUrl = URL_RAND;
        break;
    }
    final Response response = await get(fetchUrl);
    final int statusCode = response.statusCode;
    if (statusCode == 200)
      return NetworkDataHolder(poem: parseJsonBytesData(response.bodyBytes));
    else
      return NetworkDataHolder(errorOccurred: true, errorInfo: statusCode);
  } catch (e) {
    return NetworkDataHolder(errorOccurred: true, errorInfo: e);
  }
}
