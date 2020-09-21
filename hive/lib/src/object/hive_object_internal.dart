part of hive_object_internal;

/// Not part of public API
extension HiveObjectInternal on HiveObject {
  /// Not part of public API
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void init(dynamic key, BoxBase box) {
    if (connection.box != null) {
      if (connection.box != box) {
        throw HiveError('The same instance of an HiveObject cannot '
            'be stored in two different boxes.');
      } else if (connection.key != key) {
        throw HiveError('The same instance of an HiveObject cannot '
            'be stored with two different keys '
            '("${connection.key}" and "$key").');
      }
    }
    connection.box = box;
    connection.key = key;
  }

  /// Not part of public API
  void dispose() {
    for (var list in _hiveLists.keys) {
      (list as HiveListImpl).invalidate();
    }

    _hiveLists.clear();

    connection.box = null;
    connection.key = null;
  }

  /// Not part of public API
  void linkHiveList(HiveList list) {
    _requireInitialized();
    _hiveLists[list] = (_hiveLists[list] ?? 0) + 1;
  }

  /// Not part of public API
  void unlinkHiveList(HiveList list) {
    if (--_hiveLists[list] <= 0) {
      _hiveLists.remove(list);
    }
  }

  /// Not part of public API
  bool isInHiveList(HiveList list) {
    return _hiveLists.containsKey(list);
  }

  /// Not part of public API
  @visibleForTesting
  Map<HiveList, int> get debugHiveLists => _hiveLists;
}
