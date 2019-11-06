import 'dart:math' as math;

import 'src/commands.dart';

export 'src/commands.dart';
export 'src/stack.dart';

class Builder {
  final List<String> paths = [];

  String render() => paths.join(' ');

  String toString() => render();

  void add(
      /* String | Command | Iterable<String> | Iterable<Command> */ dynamic
          command) {
    if (command is String) {
      paths.add(command);
    } else if (command is Iterable<String>) {
      paths.addAll(command);
    } else if (command is Command) {
      paths.add(command.asSvg);
    } else if (command is Iterable<Command>) {
      paths.addAll(command.map((c) => c.asSvg));
    } else {
      throw ArgumentError("Invalid command");
    }
  }

  void moveTo(num x, num y, {bool relative = false}) {
    paths.add(Move(x: x, y: y, relative: relative).asSvg);
  }

  void closePath() {
    paths.add("Z");
  }

  void lineTo(num x, num y, {bool relative = false}) {
    paths.add(Line(x: x, y: y, relative: relative).asSvg);
  }

  void quadraticCurveTo(num x1, num y1, num x, num y, {bool relative = false}) {
    paths.add(Quadratic(x1: x1, y1: y1, x: x, y: y, relative: relative).asSvg);
  }

  void cubicCurveTo(num x1, num y1, num x2, num y2, num x, num y) {
    paths.add("C$x1 $y1 $x2 $y2 $x $y");
  }

  void arcTo(num rx, num ry, num xRotation, num largeArcFlag, num sweepFlag,
      num x, num y,
      {bool relative = false}) {
    paths.add(Arc(
            rx: rx,
            ry: ry,
            xRotation: xRotation,
            largeArcFlag: largeArcFlag,
            sweepFlag: sweepFlag,
            x: x,
            y: y,
            relative: relative)
        .asSvg);
  }

  void circle(num cx, num cy, num radius, {bool relative = false}) {
    paths.add(Circle(cx: cx, cy: cy, radius: radius, relative: relative).asSvg);
  }

  void rect(num x, num y, num width, num height) {
    paths.add(Move(x: x, y: y).asSvg);
    paths.add("h$width");
    paths.add("v$height");
    paths.add("h${-width}");
    paths.add("Z");
  }

  void pie(
    num radius, {
    math.Point<num> c = const math.Point<num>(0, 0),
    num innerRadius = 0,
    num startAngle = 0,
    num endAngle = 2 * math.pi,
  }) {
    final p1 = math.Point<num>(
            math.cos(startAngle) * radius, math.sin(startAngle) * radius) +
        c;
    final p2 = math.Point<num>(
            math.cos(endAngle) * radius, math.sin(endAngle) * radius) +
        c;

    final p3 = math.Point<num>(math.cos(endAngle) * innerRadius,
            math.sin(endAngle) * innerRadius) +
        c;
    final p4 = math.Point<num>(math.cos(startAngle) * innerRadius,
            math.sin(startAngle) * innerRadius) +
        c;

    moveTo(p1.x, p1.y);
    arcTo(radius, radius, 0, 0, 1, p2.x, p2.y);
    lineTo(p3.x, p3.y);
    arcTo(innerRadius, innerRadius, 0, 0, 0, p4.x, p4.y);
    lineTo(p1.x, p1.y);
    closePath();
  }

  String get asSvg => paths.join(' ');

  static final double epsilon = 1e-6;

  static final double tau = 2 * math.pi;

  static final double tauEpsilon = tau - epsilon;
}
