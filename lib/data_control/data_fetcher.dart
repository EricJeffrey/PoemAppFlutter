import 'dart:typed_data';

import 'package:http/http.dart';
import 'dart:convert';
import 'package:poem_random/data_control/data_model.dart';

const String url = "http://192.168.137.1:8000";

/// A log tools with style
/// desc: <<<xxxx>>>
void mylog(Object content, {String desc}) {
  const lf = "\n";
  print(lf);
  if (desc != null) print("$desc: ");
  print("<<<<<<<<<<<<<<<<${content.toString()}>>>>>>>>>>>>>>>>$lf");
}

/// Parse a bytes into utf-8 string, then to json, then to Poem
Poem parseJsonBytesData(Uint8List data) {
  return Poem.fromJsonMap(jsonDecode(Utf8Decoder().convert(data)));
}

/// 4 way of fetch data
enum FetchType { type_today, type_rand, type_pre, type_nxt }

/// Fetch data from server, fetch url is set by fetchType.
/// Para [day] is needed when [fetchType] is [FetchType.type_nxt] or [FetchType.type_pre]
/// TODO Store In Database
Future<NetworkDataHolder> fetchDataOfType(FetchType fetchType, {int day}) async {
  try {
    String fetchUrl;

    /// TODO change fetchUrl
    switch (fetchType) {
      case FetchType.type_today:
      case FetchType.type_pre:
      case FetchType.type_nxt:
      case FetchType.type_rand:
        fetchUrl = url;
        break;
    }
    final Response response = await get(fetchUrl);
    final int statusCode = response.statusCode;
    if (statusCode == 200) {
      return NetworkDataHolder(poem: parseJsonBytesData(response.bodyBytes));
    } else {
      return NetworkDataHolder(errorOccurred: true, errorInfo: statusCode);
    }
  } catch (e) {
    return NetworkDataHolder(errorOccurred: true, errorInfo: e);
  }
}
