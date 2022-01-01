import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DifferenceTime on DateTime {
  String parseString(AppLocalizations text) {
    final dfTime = DateTime.now().difference(this);
    if (dfTime.inMinutes == 0) {
      return text.just_now;
    } else if (dfTime.inMinutes < 60) {
      return '${dfTime.inMinutes}${text.m}';
    } else if (dfTime.inHours < 24) {
      return '${dfTime.inHours}${text.h}';
    } else {
      return dfTime.inDays < 7
          ? '${dfTime.inDays}${text.d}'
          : DateFormat('dd/MM/yyyy').format(this);
    }
  }
}
