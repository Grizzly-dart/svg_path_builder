import 'dart:html';
import 'dart:math' as math;
import 'dart:svg';

import 'package:grizzly_range/grizzly_range.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:svg_path_builder/src/area.dart';
import 'package:svg_path_builder/src/curve/curve.dart';
import 'package:svg_path_builder/svg_path_builder.dart';
import 'package:vizdom_select/selection/selection.dart';

void main() {
  final chartElement = select('#chart1');

  chartElement.select('.pie', init: SvgElement.tag('g')..classes.add('pie'),
      doo: (g) {
    g.element.setAttribute("transform", 'translate(200, 200)');
    g.select('.arc', init: SvgElement.tag('path')..classes.add('arc'),
        doo: (p) {
      p.element
        ..setAttribute('stroke', 'black')
        ..setAttribute('fill', 'orange')
        ..setAttribute('d',
            (Builder()..pie(50, /*startAngle: math.pi * 1.5,*/ endAngle: math.pi / 2, innerRadius: 35)).asSvg);
    });
  });
}
