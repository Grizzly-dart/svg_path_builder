import 'dart:math';
import 'package:svg_path_builder/svg_path_builder.dart';
import 'package:svg_path_builder/src/curve/curve.dart';

class LinearCurve implements Curve {
  const LinearCurve();

  String draw(Iterable<Point<num>> points) {
    final builder = Builder();

    for (final p in points) {
      builder.lineTo(p.x, p.y);
    }

    return builder.asSvg;
  }
}