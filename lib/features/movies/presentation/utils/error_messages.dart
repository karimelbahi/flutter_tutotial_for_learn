import 'package:easy_localization/easy_localization.dart';

/// Maps generic repository/cubit failure strings to localized UI messages.
String localizedFailureMessage(String? message) {
  switch (message) {
    case 'Network error occurred':
      return 'common.network_error'.tr();
    case 'Unexpected error occurred':
    case null:
    case '':
      return 'common.unexpected_error'.tr();
    default:
      return message;
  }
}
