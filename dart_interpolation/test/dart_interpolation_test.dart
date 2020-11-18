import 'package:flutter_test/flutter_test.dart';

import 'package:dart_interpolation/dart_interpolation.dart';

void main() {
  test('adds one to input values', () {
    List<double> v = [1,2,3,4,5,6,7];
    List<double> x = [1,2,3,4,5,6,7];
    List<double> xq = [1,2,3,4,5,6,7];
    List<double> gt = [1,2,3,4,5,6,7];
    List<double> ans = cubicSplineInterpolation(x, v, xq);
    for(int i = 0; i < ans.length; i++){
      assert(gt[i] == ans[i]);
    }
  });
}
