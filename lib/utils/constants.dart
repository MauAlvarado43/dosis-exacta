import 'package:flutter/foundation.dart';

const API_URL = "http://44.201.221.76:8000/api";

enum FREQ_TYPE { HOUR, DAILY }

extension ParseStringFreq on FREQ_TYPE {
  String get name => describeEnum(this);
}

FREQ_TYPE freqFromString(String str) => FREQ_TYPE.values.firstWhere((e) => e.toString() == 'FREQ_TYPE.' + str);

enum DURATION { DAILY, FOREVER, TEMPORARY }

extension ParseStringDuration on DURATION {
  String get name => describeEnum(this);
}

DURATION durationFromString(String str) => DURATION.values.firstWhere((e) => e.toString() == 'DURATION.' + str);