import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  String getDate(String timestamp) {
    initializeDateFormatting();
    int timeInt = int.tryParse(timestamp);
    DateTime now = DateTime.now();
    DateTime datePost = DateTime.fromMicrosecondsSinceEpoch(timeInt);
    DateFormat format;
    if (now.difference(datePost).inDays > 0) {
      format = DateFormat.yMMMd('fr_FR');
    } else {
      format = DateFormat.Hm('fr_FR');
    }
    return format.format(datePost).toString();
  }
}
