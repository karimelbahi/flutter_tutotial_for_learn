/// Mimics [MovieLocalDataSource._watchBoxValue]: first snapshot immediately,
/// then forwards later Hive box updates.
Stream<T> hiveLikeWatchStream<T>(T initialValue, Stream<T> updates) async* {
  yield initialValue;
  yield* updates;
}
