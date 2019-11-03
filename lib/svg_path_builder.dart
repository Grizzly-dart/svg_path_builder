import 'dart:math' as math;

import 'src/commands.dart';

export 'src/commands.dart';

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

  String get asSvg => paths.join(' ');

  static final double epsilon = 1e-6;

  static final double tau = 2 * math.pi;

  static final double tauEpsilon = tau - epsilon;
}
