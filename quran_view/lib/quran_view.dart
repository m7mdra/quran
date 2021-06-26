
import 'dart:async';

import 'package:flutter/services.dart';

class QuranView {
  static const MethodChannel _channel =
      const MethodChannel('quran_view');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
