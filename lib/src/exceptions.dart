class ValueNotFoundException implements Exception {
  final String key;

  ValueNotFoundException(this.key);
}