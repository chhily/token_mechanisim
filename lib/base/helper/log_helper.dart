import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

void logMessage(String value) {
  if (kDebugMode) log(value);
}

void logAsJson(dynamic data) {
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final jsonString = encoder.convert(data);
  logMessage(jsonString);
}
