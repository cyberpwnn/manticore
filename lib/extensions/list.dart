typedef T Copier<T>(T t);

extension ListExtension<T> on List<T> {
  static final Copier<T> _copier = (t) => t;

  /// Returns the last value
  T last() => length == 0 ? null : this[length - 1];

  /// Returns the middle value
  T middle() => length == 0 ? null : this[length ~/ 2];

  /// Returns the first value
  T first() => length == 0 ? null : this[0];

  /// Copies the list. Optionally pass in a copier to actually copy indices
  /// instead of copying references
  List<T> copy({Copier<T> copier}) {
    List<T> t = List<T>();
    forEach((i) => t.add((copier ?? _copier)(i)));
    return t;
  }

  /// Copies the list. Optionally pass in a copier to actually copy indices
  /// instead of copying references
  List<T> clone({Copier<T> copier}) => copy(copier: copier);
}
