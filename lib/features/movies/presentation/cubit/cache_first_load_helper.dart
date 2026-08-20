import 'dart:async';

/// Helpers for **Cache-First SSOT** cubits.
///
/// ## The race we prevent
///
/// ```
/// load() without helper:
///   listen(watch)  →  refresh() fails fast (offline)
///                     ↑ _hasCache still false — shows network error
///   watch emits cached detail (too late)
/// ```
///
/// [subscribeCacheWatch] waits for the first Hive snapshot before refresh runs.
Future<StreamSubscription<T>> subscribeCacheWatch<T>({
  required Stream<T> watch,
  required void Function(T value) onData,
  void Function(Object error)? onError,
}) async {
  final firstSnapshot = Completer<void>();

  late final StreamSubscription<T> subscription;
  subscription = watch.listen(
    (value) {
      onData(value);
      if (!firstSnapshot.isCompleted) {
        firstSnapshot.complete();
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      onError?.call(error);
      if (!firstSnapshot.isCompleted) {
        firstSnapshot.complete();
      }
    },
  );

  await firstSnapshot.future;
  return subscription;
}
