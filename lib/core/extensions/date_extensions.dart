import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  /// Local date like `dd.MM.yyyy` (uses current Intl locale for symbols)
  String toLocalDate() => DateFormat('dd.MM.yyyy', Intl.getCurrentLocale()).format(this);

  /// Friendly date+time using the system locale (e.g. German: 'Do, dd.MM. HH:mm')
  String toFriendlyDateTime() =>
      DateFormat('EEE, dd.MM. HH:mm', Intl.getCurrentLocale()).format(this);
}
