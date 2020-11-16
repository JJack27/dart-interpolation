/// Cubic spline interpolation methods
/// author: yizhou

import 'package:linalg/linalg.dart';
import 'dart:math';
/// Cubic interpolation using secondary derivatives
/// Argument
///   - x: List<dynamic>, currently only support double and int.
///   - v: List<dynamic>, only support double and int.
///   - xq: List<dynamic>, only support double and int.
/// return
///   - List<double>, the interpolation result of xq.
List<double> cubicSplineInterpolation(
    List<dynamic> x,
    List<dynamic> v,
    List<dynamic> xq){

  // Matrix objects. Ease the calculation.
  Matrix M;
  Matrix R;
  Matrix P;

  // attributes of iMatrix
  int sizeMatrix = 4 * (x.length - 1);
  int fromValEqual = 0;
  int toValEqual = x.length - 1;
  int fromFirstDerivative = (x.length - 1) * 2;
  int toFirstDerivative = 3 * x.length - 4;
  int fromSecDerivative = 3 * x.length - 4;
  int toSecDerivative = 4 * x.length - 6;
  int nKnot1 = 4 * x.length - 6;
  int nKnot2 = 4 * x.length - 5;

  // iMatrix X params = response
  List<List<double>> iMatrix = [];
  List<List<double>> response = [];


  // initialize response vector
  for(int i = 0; i < 4 * (x.length - 1); i++){
    response.add([0]);
  }
  for(int i = 0; i < x.length - 1; i++){
    response[i * 2][0] = v[i];
    response[i * 2 + 1][0] = v[i+1];
  }

  // initialize iMatrix
  for(int i = 0; i < 4 * (x.length - 1); i++){
    List<double> tempRow = [];
    for(int j = 0; j < 4 * (x.length - 1); j++){
      tempRow.add(0);
    }
    iMatrix.add(tempRow);
  }



  // filling up iMatrix
  // Filling up the value equality part
  for(int i = fromValEqual; i < toValEqual; i++){
    for(int j = i * 4; j < (i + 1) * 4; j++){
      int exp = j - i * 4;
      iMatrix[2*i][j] = pow(x[i], exp);
      iMatrix[2*i + 1][j] = pow(x[i+1], exp);
    }
  }



  // Filling up the first derivatives
  for(int i = fromFirstDerivative; i < toFirstDerivative; i++){
    for(int j = 4 * (i - 2*(x.length - 1)); j < 4 * (i - 2*(x.length - 1) + 1); j++){
      int exp = j - 4 * (i - 2*(x.length - 1))- 1;

      // first part
      iMatrix[i][j] = (exp + 1) * pow(x[i - fromFirstDerivative], exp);
      if(exp < 0){
        iMatrix[i][j] = 0;
      }

      // second part
      iMatrix[i][j+4] = (exp + 1) * -pow(x[i - fromFirstDerivative], exp);
      if(exp < 0){
        iMatrix[i][j+4] = 0;
      }
    }
  }

  // Filling up the second derivative part
  for(int i = fromSecDerivative; i < toSecDerivative; i++){
    for(int j = 4 * (i - fromSecDerivative); j < 4 * (i - fromSecDerivative + 1); j++){
      int exp = j - 4 * (i - fromSecDerivative) - 2;

      // first part
      if(exp < 0){
        iMatrix[i][j] = 0;
      }else if(exp == 0){
        iMatrix[i][j] = 2;
      }else{
        iMatrix[i][j] = 6 * x[i - fromSecDerivative + 1];
      }

      // second part
      if(exp < 0){
        iMatrix[i][j+4] = 0;
      }else if(exp == 0){
        iMatrix[i][j+4] = 2;
      }else{
        iMatrix[i][j+4] = -6 * x[i - fromSecDerivative + 1];
      }
    }
  }

  // not-knot case
  iMatrix[nKnot1][2] = 2;
  iMatrix[nKnot1][3] = 6 * (x[0]);
  iMatrix[nKnot2][sizeMatrix-2] = 2;
  iMatrix[nKnot2][sizeMatrix-1] = 6 * (x[x.length-1]);

  // Finished initializing the interpolation matrix. Convert them to Matrix objects
  M = new Matrix(iMatrix);
  R = new Matrix(response);
  P = M.inverse() * R;



  return List<double>();
}


void main(){
  List<double> v = [1,2,3,4,5,6,7];
  List<double> x = [1,2,3,4,5,6,7];
  List<double> xq = [1,2,3,4,5,6,7];

  cubicSplineInterpolation(x, v, xq);
}