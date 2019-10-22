abstract class Command {
  String get asSvg;
}

class Move implements Command {
  final num x;

  final num y;

  final bool relative;

  const Move({this.x = 0, this.y = 0, this.relative = false});

  String get asSvg => "${relative ? 'M' : 'm'}$x $y";
}

class Line implements Command {
  final num x;

  final num y;

  final bool relative;

  const Line({this.x = 0, this.y = 0, this.relative = false});

  String get asSvg => "${relative ? 'L' : 'l'}$x $y";
}

class HLine implements Command {
  final num x;

  final bool relative;

  const HLine(this.x, {this.relative = false});

  String get asSvg => "${relative ? 'H' : 'h'}$x";
}

class VLine implements Command {
  final num y;

  final bool relative;

  const VLine(this.y, {this.relative = false});

  String get asSvg => "${relative ? 'V' : 'v'}$y";
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

  String get asSvg => '${relative ? 'C' : 'c'}$x1 $y1 $x2 $y2 $x $y';
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

  String get asSvg => '${relative ? 'Q' : 'q'}$x1 $y1 $x $y';
}
