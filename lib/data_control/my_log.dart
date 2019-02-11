import 'package:flutter/foundation.dart';

/// A log tools with style
/// desc: <<<xxxx>>>
void mylog(Object content, {String desc}) {
  if (desc != null) debugPrint("$desc: ");
  debugPrint("<<<<<<<<<<<<<<<<${content.toString()}>>>>>>>>>>>>>>>>\n");
}
