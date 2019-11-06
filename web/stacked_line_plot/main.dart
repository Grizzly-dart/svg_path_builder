import 'dart:math';
import 'dart:svg';

import 'package:grizzly_range/grizzly_range.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:vizdom_select/selection/selection.dart';

void main() {
  final chartElement = select('#chart1');

  final rand = Random(555);
  final x =
      range(DateTime(2019, 11, 1), DateTime(2019, 11, 8), Duration(days: 1));
  final y1 = List<double>.generate(x.length, (_) => rand.nextDouble() * 100);
  final y2 = List<double>.generate(x.length, (_) => rand.nextDouble() * 200);
  final y3 = List<double>.generate(x.length, (_) => rand.nextDouble() * 100);

  final xScale = TimeScale(Extent.compute(x).asList(), [0, 400]);
  final yScale = LinearScale<num>([1000, 0], [0, 300]);

  // TODO

  chartElement.select('.plot1', init: SvgElement.tag('g')..classes.add('plot1'),
      doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(50, 0)');
    final lines = Line.fromPoints(x.map((x) => xScale.scale(x)).toList(),
        y.map((y) => yScale.scale(y)).toList());
    plot1.bind('.line', lines)
      ..enter((d) {
        return SvgElement.tag('line')..classes.add('line');
      })
      ..merge((ref) {
        final SvgElement line = ref.node;
        line
          ..setAttribute('stroke', 'black')
          ..setAttribute('x1', ref.data.x1.toString())
          ..setAttribute('y1', ref.data.y1.toString())
          ..setAttribute('x2', ref.data.x2.toString())
          ..setAttribute('y2', ref.data.y2.toString());
      });
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
