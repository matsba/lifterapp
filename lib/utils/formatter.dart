import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Formatter {
  String hoursMinutes(DateTime dt) => DateFormat.Hm().format(dt);
  String shortDate(DateTime dt) => DateFormat('d.M.yyyy').format(dt);
  String shortDateAndHoursMinutes(DateTime dt) =>
      DateFormat('d.M.yyyy Hm').format(dt);
  String fileFrendlyDateTime(DateTime dt) =>
      DateFormat("d_M_yyyy_H_m").format(dt);
}
