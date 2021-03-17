import 'dart:async';

class LooseMemorizer<T> {
  Future<T> get future => _completer.future;
  Completer<T> _completer = Completer<T>();

  bool get hasRun => _completer.isCompleted;

  void forget() {
    _completer = Completer<T>();
  }

  Future<T> runOnce(FutureOr<T> computation()) {
    if (!hasRun) {
      _completer.complete(Future.sync(computation));
    }
    return future;
  }
}

typedef bool Matcher(String f);

class NetworkedMemory {
  final Map<String, LooseMemorizer> memory = Map<String, LooseMemorizer>();
  final Map<String, int> ttls = Map<String, int>();

  void forgetMatching(Matcher m) {
    List<String> k = memory.keys.toList();
    for (int i = 0; i < k.length; i++) {
      if (m(k[i])) {
        forget(k[i]);
      }
    }
  }

  void forgetPrefix(String node) {
    forgetMatching((k) => k.startsWith(node));
  }

  void forget(String node) {
    memory.remove(node);
    ttls.remove(node);
  }

  void forgetEverythingYouKnow() {
    try {
      memory.clear();
    } catch (e) {}
    try {
      ttls.clear();
    } catch (e) {}
  }

  Future<T> runEvery<T>(String node, int ttl, FutureOr<T> computation()) async {
    int nttl = (ttl.toDouble()).toInt();

    if (!ttls.containsKey(node)) {
      ttls[node] = DateTime.now().millisecondsSinceEpoch + nttl;
    } else {
      if (ttls[node] < DateTime.now().millisecondsSinceEpoch) {
        forget(node);
      }
    }

    return runOnce(node, computation);
  }

  Future<T> runOnce<T>(String node, FutureOr<T> computation()) async {
    return await (memory[node] as LooseMemorizer<T>).runOnce(computation);
  }
}
