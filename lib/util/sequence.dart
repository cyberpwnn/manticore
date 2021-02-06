import 'dart:math';

import 'package:manticore/extensions/list.dart';

class Sequence {
  List<double> data;
  double average;
  bool dirty;
  int currentIndex;
  int size;
  double median;
  double vmax;
  double vmin;
  bool dirtyMedian;
  int dirtyExtremes;
  bool precision;

  Sequence(int size) {
    this.size = size;
    data = List<double>();
    clear(0);
    put(0);

    median = 0;
    vmin = 0;
    vmax = 0;
    setPrecision(false);
  }

  void put(double d) {
    currentIndex = currentIndex >= data.length ? 0 : currentIndex;
    data[currentIndex++] = d;
    dirty = true;
    dirtyMedian = true;
    dirtyExtremes++;
    vmax = max(vmax, d);
    vmin = min(vmin, d);
  }

  double get() {
    if (dirty) {
      average = computeAverage();
      dirty = false;
    }

    return average;
  }

  double computeAverage() {
    try {
      double a = 0;

      for (int i = 0; i < data.length; i++) {
        a += data[i];
      }

      return a / data.length;
    } catch (e) {}

    return 0;
  }

  void clear(double v) {
    data.clear();
    for (int i = 0; i < size; i++) {
      data.add(v);
    }
    average = v;
    dirty = false;
  }

  double addLast(int amt) {
    double f = 0;

    for (int i = 0; i < min(data.length, amt); i++) {
      f += data[i];
    }

    return f;
  }

  void setPrecision(bool p) {
    this.precision = p;
  }

  bool isPrecision() {
    return precision;
  }

  double getMin() {
    if (dirtyExtremes > (isPrecision() ? 0 : data.length)) {
      resetExtremes();
    }

    return vmin;
  }

  double getMax() {
    if (dirtyExtremes > (isPrecision() ? 0 : data.length)) {
      resetExtremes();
    }

    return vmax;
  }

  double getMedian() {
    if (dirtyMedian) {
      recalculateMedian();
    }

    return median;
  }

  void recalculateMedian() {
    List<double> v = data.copy();
    v.sort((a, b) => ((a - b) * 10000).round());
    median = v.middle();
    dirtyMedian = false;
  }

  void resetExtremes() {
    vmax = -10000000000000;
    vmin = 10000000000000;
    data.forEach((i) {
      vmax = max(vmax, i);
      vmin = min(vmin, i);
    });
    dirtyExtremes = 0;
  }
}
