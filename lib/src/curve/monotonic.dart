import 'dart:math';
import 'package:svg_path_builder/svg_path_builder.dart';
import 'package:svg_path_builder/src/curve/curve.dart';

class MonotonicCurve implements Curve {
  const MonotonicCurve();

  String draw(Iterable<Point<num>> points) {
    final builder = Builder();

    if (points.length < 3) {
      return ""; // TODO
    }

    final iter = points.iterator;
    Point<num> p0 = (iter..moveNext()).current;
    Point<num> p1 = (iter..moveNext()).current;
    num t0;

    for (final p in points.skip(2)) {
      num t1 = slope3(p0, p1, p);
      if (t0 == null) {
        t0 = slope2(p0, p1, t1);
        bezierCurveTo(builder, p0, p1, t0, t1);
      } else {
        bezierCurveTo(builder, p0, p1, t0, t1);
      }
      p0 = p1;
      p1 = p;
      t0 = t1;
    }

    bezierCurveTo(builder, p0, p1, t0, slope2(p0, p1, t0));

    return builder.asSvg;
  }

  /// Calculates one-sided slope
  static num slope2(Point<num> p0, Point<num> p1, num t) {
    final num dx = p1.x - p0.x;
    if (dx == 0) {
      return t;
    } else {
      return (3 * (p1.y - p0.y) / dx - t) / 2;
    }
  }

  static int _sign(num inp) => inp < 0 ? -1 : 1;

  static num slope3(Point<num> p0, Point<num> p1, Point<num> p2) {
    final num h0 = p1.x - p0.x;
    final num h1 = p2.x - p1.x;
    num s0 = (p1.y - p0.y);
    num s1 = (p2.y - p1.y);
    if (h0 != 0) {
      s0 /= h0;
    } else {
      if (h1 < 0) {
        s0 = double.infinity;
      } else {
        s0 = double.negativeInfinity;
      }
    }
    if (h1 != 0) {
      s1 /= h1;
    } else {
      if (h0 < 0) {
        s1 = double.infinity;
      } else {
        s1 = double.negativeInfinity;
      }
    }
    final num p = (s0 * h1 + s1 * h0) / (h0 + h1);
    final num ret =
        (_sign(s0) + _sign(s1)) * min(s0.abs(), min(s1.abs(), 0.5 * p.abs()));
    if (ret == double.nan) {
      return 0;
    } else {
      return ret;
    }
  }

  static void bezierCurveTo(
      Builder builder, Point<num> p0, Point<num> p1, num t0, num t1) {
    final num dx = (p1.x - p0.x) / 3;
    builder.cubicCurveTo(
      p0.x + dx,
      p0.y + dx * t0,
      p1.x - dx,
      p1.y - dx * t1,
      p1.x,
      p1.y,
    );
  }
}
