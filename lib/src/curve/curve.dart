import 'dart:math';

import 'linear.dart';
import 'monotonic.dart';

export 'linear.dart';
export 'monotonic.dart';

abstract class Curve {
  String draw(Iterable<Point<num>> points);

  static LinearCurve linear() => LinearCurve();

  static MonotonicCurve monotonic() => MonotonicCurve();
}
