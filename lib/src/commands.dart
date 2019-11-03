abstract class Command {
  String get asSvg;
}

class Move implements Command {
  final num x;

  final num y;

  final bool relative;

  const Move({this.x = 0, this.y = 0, this.relative = false});

  String get asSvg => "${relative ? 'm' : 'M'}$x $y";
}

class Line implements Command {
  final num x;

  final num y;

  final bool relative;

  const Line({this.x = 0, this.y = 0, this.relative = false});

  String get asSvg => "${relative ? 'l' : 'L'}$x $y";
}

class HLine implements Command {
  final num x;

  final bool relative;

  const HLine(this.x, {this.relative = false});

  String get asSvg => "${relative ? 'h' : 'H'}$x";
}

class VLine implements Command {
  final num y;

  final bool relative;

  const VLine(this.y, {this.relative = false});

  String get asSvg => "${relative ? 'v' : 'V'}$y";
}

class ClosePath implements Command {
  const ClosePath();

  String get asSvg => 'Z';
}

class Cubic implements Command {
  final num x1;

  final num y1;

  final num x2;

  final num y2;

  final num x;

  final num y;

  final bool relative;

  const Cubic(
      {this.x1 = 0,
      this.y1 = 0,
      this.x2 = 0,
      this.y2 = 0,
      this.x = 0,
      this.y = 0,
      this.relative = false});

  String get asSvg => '${relative ? 'c' : 'C'}$x1 $y1 $x2 $y2 $x $y';
}

class Quadratic implements Command {
  final num x1;

  final num y1;

  final num x;

  final num y;

  final bool relative;

  const Quadratic(
      {this.x1 = 0,
      this.y1 = 0,
      this.x = 0,
      this.y = 0,
      this.relative = false});

  String get asSvg => '${relative ? 'q' : 'Q'}$x1 $y1 $x $y';
}

class Arc implements Command {
  final num rx;

  final num ry;

  final num xRotation;

  final num largeArcFlag;

  final num sweepFlag;

  final num x;

  final num y;

  final bool relative;

  Arc({
    this.rx,
    this.ry,
    this.xRotation,
    this.largeArcFlag,
    this.sweepFlag,
    this.x,
    this.y,
    this.relative = false,
  });

  String get asSvg =>
      '${relative ? 'a' : 'A'} $rx $ry $xRotation $largeArcFlag $sweepFlag $x $y';
}

class Circle implements Command {
  final num cx;

  final num cy;

  final num radius;

  final bool relative;

  Circle({this.cx = 0, this.cy = 0, this.radius, this.relative = false});

  String get asSvg => [
        Move(x: cx, y: cy, relative: relative),
        Move(x: -radius, y: 0, relative: true),
        Arc(
            rx: radius,
            ry: radius,
            xRotation: 0,
            largeArcFlag: 1,
            sweepFlag: 0,
            x: radius * 2,
            y: 0,
            relative: true),
        Arc(
            rx: radius,
            ry: radius,
            xRotation: 0,
            largeArcFlag: 1,
            sweepFlag: 0,
            x: -radius * 2,
            y: 0,
            relative: true),
      ].map((c) => c.asSvg).join(' ');
}
