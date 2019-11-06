import 'dart:math';

import 'package:grizzly_stat/grizzly_stat.dart';

num _identityValues(d) => d as num;

Iterable<PieSlice> pie<T>(Iterable<T> data,
    {num startAngle = 0,
    num endAngle = 2 * pi,
    num padding = 0,
    num Function(T data) valuer = _identityValues}) {
  final numData = data.length;
  final values = data.map(valuer);

  final int dir = (endAngle > startAngle)? 1: -1;

  final totalAngle = (endAngle - startAngle) * dir;
  final totalPadding = padding * (numData - 1);

  final s = sum(values);

  final dataIter = data.iterator;
  final valueIter = values.iterator;

  final centage = (totalAngle - totalPadding) / s;

  num angle = startAngle;

  final ret = <PieSlice<T>>[]..length = numData;

  for (int i = 0; i < numData; i++) {
    final d = (dataIter..moveNext()).current;
    final v = (valueIter..moveNext()).current;

    final curAngle = v * centage;

    ret[i] = PieSlice<T>(angle, angle + (curAngle * dir),
        padding: padding, data: d, index: i, value: v);

    angle += (curAngle + padding) * dir;
  }

  return ret;
}

class PieSlice<T> {
  num start;

  num end;

  num padding;

  int index;

  T data;

  num value;

  PieSlice(this.start, this.end,
      {this.padding = 0, this.index, this.data, this.value});
}
