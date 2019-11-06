import 'package:grizzly_range/grizzly_range.dart';

Stack stack<T, KT>(Iterable<KT> keys, Iterable<T> domain,
    num Function(KT key, T domain) getter,
    {num offset = 0}) {
  final numCurves = keys.length;
  final numDomain = domain.length;
  final ret = List<List<Extent<num>>>()..length = numCurves;

  for (int i = 0; i < numCurves; i++) {
    ret[i] = []..length = numDomain;
  }

  int i = 0;
  for (final d in domain) {
    num sum = offset;
    int j = 0;
    for (final k in keys) {
      num value = getter(k, d);
      ret[j][i] = Extent<num>(sum, sum + value);
      sum += value;
      j++;
    }
    i++;
  }

  return Stack(ret);
}

Stack stackBar<T, KT>(Iterable<KT> keys, Iterable<T> domain,
    num Function(KT key, T domain) getter,
    {num offset = 0}) {
  final numCurves = keys.length;
  final numDomain = domain.length;
  final ret = List<List<Extent<num>>>()..length = numDomain;

  for (int i = 0; i < numDomain; i++) {
    ret[i] = []..length = numCurves;
  }

  int i = 0;
  for (final d in domain) {
    num sum = offset;
    int j = 0;
    for (final k in keys) {
      num value = getter(k, d);
      ret[i][j] = Extent<num>(sum, sum + value);
      sum += value;
      j++;
    }
    i++;
  }

  return Stack(ret);
}

class Stack {
  final List<List<Extent<num>>> data;

  Stack(this.data);

  Extent<num> get extent => Extent.mergeExtents(extents);

  Iterable<Extent<num>> get extents => data.map((d) => Extent.mergeExtents(d));
}
