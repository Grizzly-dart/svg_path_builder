import 'dart:svg';

import 'package:grizzly_range/grizzly_range.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:svg_path_builder/svg_path_builder.dart';
import 'package:vizdom_select/selection/selection.dart';

final colors = ["#b33040", "#d25c4d", "#f2b447", "#d9d574"];

void main() {
  final chartElement = select('#chart1');

  final x = data.map((d) => d['year']);
  final y = stackBar(["redDelicious", "mcintosh", "oranges", "pears"],
      indices(x.length), (cn, index) => data[index][cn] as num);

  final xScale = BandScale(x, [0, 1000], padding: 0.05);
  final yScale = LinearScale([y.extent.lower, y.extent.upper], [350, 0]);

  chartElement.select('.plot1', init: SvgElement.tag('g')..classes.add('plot1'),
      doo: (plot1) {
    plot1.element.setAttribute('transform', 'translate(0, 0)');

    plot1.bind('.bar-stack', y.data)
      ..enter((d) => SvgElement.tag('g')..classes.add('bar-stack'))
      ..merge((ref) {
        final d = x.elementAt(ref.dataIndex);
        final left = xScale.bound(d);
        final width = xScale.size;

        final rects = indices(ref.data.length).map((i) {
          final r = ref.data.elementAt(i);

          final pY = yScale.scale(r.lower);
          final height = yScale.scale(r.upper - r.lower) - yScale.range.first;

          return Rect(left, pY, width, height);
        }).toList();

        ref.bind('.bar', rects)
          ..enter((d) => SvgElement.tag('rect')..classes.add('bar'))
          ..merge((ref) {
            final SvgElement line = ref.node;
            line
              ..setAttribute('stroke', 'none')
              ..setAttribute('x', ref.data.x.toString())
              ..setAttribute('y', ref.data.y.toString())
              ..setAttribute('width', ref.data.width.toString())
              ..setAttribute('height', ref.data.height.toString())
              ..setAttribute('fill', colors[ref.dataIndex]);
          });
      });
  });
}

class Rect {
  final num x;

  final num y;

  final num width;

  final num height;

  Rect._(this.x, this.y, this.width, this.height);

  factory Rect(num x, num y, num width, num height) {
    if (width.isNegative) {
      width = -width;
      x -= width;
    }
    if (height.isNegative) {
      height = -height;
      y -= height;
    }

    return Rect._(x, y, width, height);
  }
}

final data = [
  {
    "year": "2006",
    "redDelicious": 10,
    "mcintosh": 15,
    "oranges": 9,
    "pears": 6
  },
  {
    "year": "2007",
    "redDelicious": 12,
    "mcintosh": 18,
    "oranges": 9,
    "pears": 4
  },
  {"year": "2008", "redDelicious": 5, "mcintosh": 20, "oranges": 8, "pears": 2},
  {"year": "2009", "redDelicious": 1, "mcintosh": 15, "oranges": 5, "pears": 4},
  {"year": "2010", "redDelicious": 2, "mcintosh": 10, "oranges": 4, "pears": 2},
  {"year": "2011", "redDelicious": 3, "mcintosh": 12, "oranges": 6, "pears": 3},
  {"year": "2012", "redDelicious": 4, "mcintosh": 15, "oranges": 8, "pears": 1},
  {"year": "2013", "redDelicious": 6, "mcintosh": 11, "oranges": 9, "pears": 4},
  {
    "year": "2014",
    "redDelicious": 10,
    "mcintosh": 13,
    "oranges": 9,
    "pears": 5
  },
  {
    "year": "2015",
    "redDelicious": 16,
    "mcintosh": 19,
    "oranges": 6,
    "pears": 9
  },
  {
    "year": "2016",
    "redDelicious": 19,
    "mcintosh": 17,
    "oranges": 5,
    "pears": 7
  },
];
