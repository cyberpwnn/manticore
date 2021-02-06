typedef T Copier<T>(T t);

extension MapExtension<T, V> on Map<T, V> {
  static final Copier<T> _tcopier = (t) => t;
  static final Copier<V> _vcopier = (v) => v;

  /// Copies the map. Optionally pass in a key copier and a value copier to actually copy indices
  /// instead of copying references
  Map<T, V> copy({Copier<T> kcopier, Copier<V> vcopier}) {
    Map<T, V> t = Map<T, V>();
    keys.forEach(
        (i) => t[(kcopier ?? _tcopier)(i)] = ((vcopier ?? _vcopier)(this[i])));
    return t;
  }

  /// Copies the map. Optionally pass in a key copier and a value copier to actually copy indices
  /// instead of copying references
  Map<T, V> clone({Copier<T> kcopier, Copier<V> vcopier}) =>
      copy(kcopier: kcopier, vcopier: vcopier);
}
