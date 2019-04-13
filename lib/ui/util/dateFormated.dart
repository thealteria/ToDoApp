import 'package:intl/intl.dart';

String dateFormated() {
  var now = DateTime.now();

  var formatter = new DateFormat("hh:mm aaa, d/MM/yyyy");
  String formatted = formatter.format(now);
  return formatted;
}
