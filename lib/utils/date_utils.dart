
import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate({required DateTime date}) {
    return DateFormat("dd/mm/yyyy @ hh:mm a").format(date);
  }
}