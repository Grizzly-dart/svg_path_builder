import 'dart:math';
import 'package:svg_path_builder/src/curve/curve.dart';
import 'package:svg_path_builder/svg_path_builder.dart';

typedef ToPoint<DT> = Point<num> Function(DT object);

typedef BaseLineMapper<DT> = Point<num> Function(DT data, Point<num> point);

typedef IsDefined<DT> = bool Function(DT object);

bool _alwaysDefined(_) => true;

String area<DT>(Iterable<DT> data,
    {ToPoint<DT> mapper,
    BaseLineMapper<DT> baseLineMapper,
    IsDefined<DT> isDefined = _alwaysDefined,
    Curve curve = const LinearCurve(),
    Curve baseLineCurve = const LinearCurve()}) {
  final builder = Builder();

  var currentLine = <Point>[];
  var currentBaseLine = <Point>[];

  Point<num> addPoint(DT data) {
    final point = mapper(data);
    currentLine.add(point);

    final basePoint = baseLineMapper(data, point);
    currentBaseLine.add(basePoint);

    return point;
  }

  void draw() {
    if (currentLine.isNotEmpty) {
      builder.moveTo(currentLine.first.x, currentLine.first.y);
      builder.add(curve.draw(currentLine));
      if (currentBaseLine.isNotEmpty) {
        builder.lineTo(currentBaseLine.last.x, currentBaseLine.last.y);
        builder.add(baseLineCurve.draw(currentBaseLine.reversed));
        builder.lineTo(currentLine.first.x, currentLine.first.y);
      }
    }

    currentLine = <Point>[];
    currentBaseLine = <Point>[];
  }

  final iter = data.iterator;
  bool defined = false;
  while (iter.moveNext()) {
    final current = iter.current;
    final curDefined = isDefined(current);

    if (!curDefined) {
      if (defined) {
        draw();
        defined = false;
      }
      continue;
    }

    if (!defined) {
      final point = addPoint(current);
      builder.moveTo(point.x, point.y);
      defined = true;
    } else {
      addPoint(current);
    }
  }

  if (defined) {
    draw();
    defined = false;
  }

  return builder.asSvg;
}

String line<DT>(List<DT> data,
    {ToPoint<DT> mapper,
    IsDefined<DT> isDefined = _alwaysDefined,
    Curve curve = const LinearCurve()}) {
  final builder = Builder();

  var currentLine = <Point>[];
  final iter = data.iterator;
  bool defined = false;
  while (iter.moveNext()) {
    final current = iter.current;
    final curDefined = isDefined(current);

    if (!curDefined) {
      if (defined) {
        builder.add(curve.draw(currentLine));
        currentLine = <Point>[];
        defined = false;
      }
      continue;
    }

    final point = mapper(current);
    if (!defined) {
      builder.moveTo(point.x, point.y);
      currentLine.add(point);
      defined = true;
    } else {
      currentLine.add(point);
    }
  }

  if (defined) {
    builder.add(curve.draw(currentLine));
    currentLine = <Point>[];
    defined = false;
  }

  return builder.asSvg;
}

String point<DT>(
  List<DT> data, {
  ToPoint<DT> mapper,
  ShapePainter shape = const CirclePainter(),
  IsDefined<DT> isDefined = _alwaysDefined,
  num radius = 10,
}) {
  final builder = Builder();

  for (final current in data) {
    if (!isDefined(current)) continue;

    final point = mapper(current);
    builder..add(shape.draw(point, radius));
  }

  return builder.asSvg;
}

abstract class ShapePainter {
  String draw(Point<num> at, num radius);
}

class CirclePainter implements ShapePainter {
  const CirclePainter();

  String draw(Point<num> at, num radius) =>
      Circle(cx: at.x, cy: at.y, radius: radius).asSvg;
}
