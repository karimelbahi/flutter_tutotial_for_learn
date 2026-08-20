import 'package:easy_localization/easy_localization.dart';

/// Formats TMDB runtime minutes for the detail header.
String formatRuntimeMinutes(int? minutes) {
  if (minutes == null || minutes <= 0) {
    return 'common.tba'.tr();
  }

  final hours = minutes ~/ 60;
  final mins = minutes % 60;

  if (hours == 0) {
    return '${mins}m';
  }
  if (mins == 0) {
    return '${hours}h';
  }
  return '${hours}h ${mins}m';
}
