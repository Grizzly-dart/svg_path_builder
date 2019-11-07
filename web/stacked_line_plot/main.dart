import 'dart:math' as math;
import 'dart:svg';

import 'package:grizzly_range/grizzly_range.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:svg_path_builder/src/area.dart';
import 'package:svg_path_builder/svg_path_builder.dart';
import 'package:vizdom_select/selection/selection.dart';

final colors = ["#b33040", "#d25c4d", "#f2b447", "#d9d574"];

void main() {
  final chartElement = select('#chart1');

  final rand = math.Random(555);
  final x =
      range(DateTime(2019, 11, 1), DateTime(2019, 11, 8), Duration(days: 1))
          .toList();
  final y1 = List<double>.generate(x.length, (_) => rand.nextDouble() * 20);
  final y2 = List<double>.generate(x.length, (_) => rand.nextDouble() * 50);
  final y3 = List<double>.generate(x.length, (_) => rand.nextDouble() * 20);

  final ys = <List<double>>[y1, y2, y3];

  final stackedY = stack<dynamic, int>(indices(ys), x, (k, i, _) => ys[k][i]);

  print(stackedY.data[0]);

  final xScale = TimeScale(Extent.compute(x).asList(), [0, 450]);
  final yScale = LinearScale<num>([stackedY.extent.upper, 0], [0, 350]);

  chartElement.select('.plot1', init: SvgElement.tag('g')..classes.add('plot1'),
      doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(0, 0)');

    plot1.bind('signal', stackedY.data)
      ..enter((ref) => SvgElement.tag('path')..classes.add('signal'))
      ..merge((ref) {
        ref.element
          ..setAttribute('fill', colors[ref.dataIndex])
          ..setAttribute('stroke', 'none')
          ..setAttribute(
              'd',
              area(indices(x),
                  mapper: (i) => math.Point<num>(
                      xScale.scale(x[i]), yScale.scale(ref.data[i].upper)),
                  baseLineMapper: (i, p) =>
                      math.Point<num>(p.x, yScale.scale(ref.data[i].lower))));
      });
  });
}
