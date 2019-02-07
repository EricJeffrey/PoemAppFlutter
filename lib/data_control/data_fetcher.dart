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

Poem parseJsonBytesData(Uint8List data) {
  return Poem.fromJsonMap(jsonDecode(Utf8Decoder().convert(data)));
}

/// Fetch today's poem data.
/// Return a NetworkDataHolder object contains data or error
/// TODO Store In Database
Future<NetworkDataHolder> fetchDataToday() async {
  final Response response = await get(url);
  final int statusCode = response.statusCode;
  if (statusCode == 200)
    return NetworkDataHolder(poem: parseJsonBytesData(response.bodyBytes));
  else
    return NetworkDataHolder(errorOccurred: true, errorInfo: statusCode);
}

/// Fetch poem data of specific [day].
/// day - days count from 2019/1/1
/// TODO Add Parameter
Future<NetworkDataHolder> fetchDataOfDay(int day) async {
  final Response response = await get("$url");
  final int statusCode = response.statusCode;
  if (statusCode == 200)
    return NetworkDataHolder(poem: parseJsonBytesData(response.bodyBytes));
  else
    return NetworkDataHolder(errorOccurred: true, errorInfo: statusCode);
}

/// Fetch a random data
/// TODO add parameter
Future<NetworkDataHolder> fetchDataRandom() async {
  final Response response = await get("$url");
  final int statusCode = response.statusCode;
  if (statusCode == 200)
    return NetworkDataHolder(poem: parseJsonBytesData(response.bodyBytes));
  else
    return NetworkDataHolder(errorOccurred: true, errorInfo: statusCode);
}
