import 'package:intl/intl.dart';

const rfc822DatePattern = 'EEE, dd MMM yyyy HH:mm:ss Z';

const _parseFormat = {
  '\\d{4}/\\d{2}/\\d{2} \\d{2}:\\d{2}:\\d{2}': 'yyyy/MM/dd HH:mm:ss',
  '\\d{4}/\\d{2}/\\d{2} \\d{2}:\\d{2}': 'yyyy/MM/dd HH:mm',
  '\\d{4}/\\d{2}/\\d{2} \\d{2}': 'yyyy/MM/dd HH',
  '\\d{4}/\\d{2}/\\d{2}': 'yyyy/MM/dd',
};

DateTime parseDateTime(dateString) {
  if (dateString == null) return null;
  return _parseRfc822DateTime(dateString) ?? _parseIso8601DateTime(dateString) ?? _parseDateTime(dateString);
}

DateTime _parseRfc822DateTime(String dateString) {
  try {
    final length = dateString?.length?.clamp(0, rfc822DatePattern.length);
    final trimmedPattern = rfc822DatePattern.substring(0, length); //Some feeds use a shortened RFC 822 date, e.g. 'Tue, 04 Aug 2020'
    final format = DateFormat(trimmedPattern, 'en_US');
    return format.parse(dateString);
  } on FormatException {
    return null;
  }
}

DateTime _parseIso8601DateTime(dateString) {
  try {
    return DateTime.parse(dateString);
  } on FormatException {
    return null;
  }
}

DateTime _parseDateTime(dateString) {
  try {
    for (var regex in _parseFormat.keys) {
      var dateFormat = RegExp(regex);
      if (dateFormat.hasMatch(dateString)) {
        return DateFormat(_parseFormat[regex]).parse(dateString);
      }
    }
    return null;
  } on FormatException {
    return null;
  }
}
