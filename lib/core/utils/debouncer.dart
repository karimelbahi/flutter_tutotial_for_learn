import 'dart:async';

import 'package:flutter/foundation.dart';

/// Delays rapid callbacks — used by the search screen to debounce API calls.
///
/// Ported from reference `lib/utils/debouncer.dart`.
/// Default delay matches reference search screen: 1000 ms.
class Debouncer {
  Debouncer({this.milliseconds = 1000});

  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels a pending debounced action (e.g. when the user clears search).
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    cancel();
  }
}
