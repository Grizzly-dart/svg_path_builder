import 'dart:html';
import 'dart:math' as math;
import 'dart:svg';

import 'package:grizzly_range/grizzly_range.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:svg_path_builder/src/area.dart';
import 'package:svg_path_builder/src/curve/curve.dart';
import 'package:vizdom_select/selection/selection.dart';

void main() {
  final chartElement = select('#chart1');

  final rand = math.Random(555);
  final x =
      range(DateTime(2019, 11, 1), DateTime(2019, 11, 30), Duration(days: 5))
          .toList();
  final y = List<double>.generate(x.length, (_) => rand.nextDouble() * 1000);

  final xScale = TimeScale(Extent.compute(x).asList(), [0, 450]);
  final yScale = LinearScale<num>([1000, 0], [0, 350]);

  print(x.map((v) => xScale.scale(v)).toList());
  print(y.map((v) => yScale.scale(v)).toList());

  /*
  chartElement.select(':scope > .linear',
      init: SvgElement.tag('g')..classes.add('linear'), doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(0, 0)');

    final lines = Line.fromPoints(x.map((x) => xScale.scale(x)).toList(),
        y.map((y) => yScale.scale(y)).toList());
    plot1.bind('.line', lines)
      ..enter((d) {
        return SvgElement.tag('line')..classes.add('line');
      })
      ..merge((ref) {
        final SvgElement line = ref.node;
        line
          ..setAttribute('stroke', 'green')
          ..setAttribute('x1', ref.data.x1.toString())
          ..setAttribute('y1', ref.data.y1.toString())
          ..setAttribute('x2', ref.data.x2.toString())
          ..setAttribute('y2', ref.data.y2.toString());
      });
  });

  chartElement.select(':scope > .point',
      init: SvgElement.tag('g')..classes.add('point'), doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(0, 0)');
    final lineEl = SvgElement.tag('path')
      ..setAttribute('fill', 'orange')
      ..setAttribute('stroke', 'none')
      ..setAttribute(
          'd',
          point(indices(x.length).toList(),
              mapper: (i) =>
                  math.Point<num>(xScale.scale(x[i]), yScale.scale(y[i])),
              radius: 3));
    plot1.element.children.add(lineEl);
  });

  chartElement.select(':scope > .line',
      init: SvgElement.tag('g')..classes.add('line'), doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(0, 0)');
    final lineEl = SvgElement.tag('path')
      ..setAttribute('fill', 'none')
      ..setAttribute('stroke', 'black')
      ..setAttribute(
          'd',
          line(indices(x.length).toList(),
              mapper: (i) =>
                  math.Point<num>(xScale.scale(x[i]), yScale.scale(y[i]))));
    plot1.element.children.add(lineEl);
  });
   */

  chartElement.select(':scope > .monotonex',
      init: SvgElement.tag('g')..classes.add('monotonex'), doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(0, 0)');
    final lineEl = SvgElement.tag('path')
      ..setAttribute('fill', 'none')
      ..setAttribute('stroke', 'black')
      ..setAttribute(
          'd',
          line(indices(x.length).toList(),
              mapper: (i) =>
                  math.Point<num>(xScale.scale(x[i]), yScale.scale(y[i])),
              curve: MonotonicCurve()));
    plot1.element.children.add(lineEl);
  });
}

class Line {
  num x1;

  num y1;

  num x2;

  num y2;

  Line(this.x1, this.y1, this.x2, this.y2);

  static List<Line> fromPoints(List<num> x, List<num> y) {
    num curX = x.first;
    num curY = y.first;

    final ret = List<Line>()..length = x.length - 1;
    for (int i = 1; i < x.length; i++) {
      num nextX = x[i];
      num nextY = y[i];
      ret[i - 1] = Line(curX, curY, nextX, nextY);
      curX = nextX;
      curY = nextY;
    }

    return ret;
  }
}
