import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef Widget SnapBuilder(BuildContext context);
typedef Widget SnapshotBuilder(BuildContext context, Widget snapshot);

class SnapshotWidget extends StatefulWidget {
  final SnapBuilder builder;
  final SnapshotBuilder snapBuilder;
  final double quality;
  final int snapDelay;
  static _SnapshotWidgetState of(BuildContext context) =>
      context.findAncestorStateOfType<State<SnapshotWidget>>();

  SnapshotWidget(
      {this.builder, this.snapDelay = 20, this.snapBuilder, this.quality = 1})
      : super(key: UniqueKey());

  @override
  _SnapshotWidgetState createState() => _SnapshotWidgetState(
      snapDelay: snapDelay,
      builder: builder,
      snapshotBuilder: snapBuilder,
      quality: quality);
}

class _SnapshotWidgetState extends State<SnapshotWidget> {
  final SnapBuilder builder;
  final int snapDelay;
  final GlobalKey _globalKey = new GlobalKey();
  final double quality;
  final SnapshotBuilder snapshotBuilder;
  Uint8List snapshot;
  bool snapping = false;

  _SnapshotWidgetState(
      {this.builder, this.snapDelay, this.quality, this.snapshotBuilder});

  void invalidate() {
    snapshot = null;
  }

  Future<Uint8List> capture() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      return (await (await boundary.toImage(pixelRatio: quality))
              .toByteData(format: ui.ImageByteFormat.png))
          .buffer
          .asUint8List();
    } catch (e) {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return builder(context);
    }

    Widget ww;

    if (snapshot != null) {
      if (snapping) {
        snapping = false;
        ww = snapshotBuilder != null
            ? snapshotBuilder(
                context,
                Container(
                  child: Image(image: MemoryImage(snapshot, scale: quality)),
                ))
            : Container(
                child: Image(image: MemoryImage(snapshot, scale: quality)),
              );
      }
    }

    if (ww == null) {
      Widget w = builder(context);
      Future.delayed(Duration(milliseconds: max(snapDelay, 20)), () {
        try {
          capture().then((s) {
            if (s != null) {
              snapping = true;
              try {
                setState(() {
                  snapshot = s;
                });
              } catch (e) {}
            }
          });
        } catch (e) {}
      });
      ww = RepaintBoundary(
        key: _globalKey,
        child: w,
      );
    }

    return Container(
      child: ww,
      key: UniqueKey(),
    );
  }
}
