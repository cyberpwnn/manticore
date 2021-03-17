import 'package:flutter/material.dart';

typedef bool Predicate<X>(X x);
typedef Widget WBuilder<T>(BuildContext context, T t);
typedef Widget LBuilder(BuildContext context);
typedef X Callback<X>();

extension FutureExtension<T> on Future<T> {
  /// Will also tack on the given future to the existing (instance) future.
  /// The resulting future will only complete once both futures have completed
  Future<V> and<V>(Future<V> v) async =>
      Future.wait(<Future>[this, v]).then((r) => r[1]);

  /// If the given predicate is true (checked when the future completes)
  /// Invoke the callback result, otherwise returns null
  Future<G> predicate<G>(Predicate<T> predicate, Callback<G> callback) =>
      this.then((f) {
        if (predicate(f)) {
          return callback();
        }

        return null;
      });

  /// Returns a futurebuilder out of this future
  /// Provide a builder(data, context) and a loading(context) builder
  FutureBuilder<T> build({
    WBuilder builder,
    LBuilder loading,
  }) =>
      FutureBuilder(
        builder: (context, snap) {
          if (!snap.hasData) {
            return loading != null ? loading(context) : Container();
          }

          return builder != null ? builder(context, snap.data) : Container();
        },
        future: this,
      );
}
