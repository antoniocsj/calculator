import 'dart:math';
import 'package:complex/complex.dart';
import 'enums.dart';

typedef BitwiseFunc = int Function(int v1, int v2);

class Number {
  late Complex num;
  static String? error;

  Number() : num = Complex(0, 0);

  Number.integer(int real, [int imag = 0]) {
    num = Complex(real.toDouble(), imag.toDouble());
  }

  Number.unsignedInteger(int real, [int imag = 0]) {
    num = Complex(real.toDouble(), imag.toDouble());
  }

  Number.fraction(int numerator, int denominator) {
    if (denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
    num = Complex(numerator.toDouble(), 0);
    if (denominator != 1) {
      num = num / Complex(denominator.toDouble(), 0);
    }
  }

  Number.double(double real, [double imag = 0]) : num = Complex(0, 0) {
    num = Complex(real, imag);
  }

  Number.complex(Number r, Number i) : num = Complex(0, 0) {
    num = Complex(r.num.real, i.num.real);
  }

  Number.polar(Number r, Number theta, [AngleUnit unit = AngleUnit.radians]) : num = Complex(0, 0) {
    var x = theta.cos(unit);
    var y = theta.sin(unit);
    num = Complex(x.num.real, y.num.real);
    num = num * r.num;
  }

  Number.eulers() : num = Complex(0, 0) {
    num = Complex(2.718281828459045, 0);
  }

  Number.i() : num = Complex(0, 0) {
    num = Complex(0, 1);
  }

  Number.pi() : num = Complex(0, 0) {
    num = Complex(3.141592653589793, 0);
  }

  Number.tau() : num = Complex(0, 0) {
    num = Complex(6.283185307179586, 0);
  }

  Number.random() : num = Complex(0, 0) {
    // this.double(Random().nextDouble());
    num = Complex(Random().nextDouble(), 0);
  }

  int toInteger() {
    return num.real.toInt();
  }

  int toUnsignedInteger() {
    return num.real.toInt();
  }

  double toFloat() {
    return num.real;
  }

  double toDouble() {
    return num.real;
  }

  bool isZero() {
    return num.real == 0 && num.imaginary == 0;
  }

  bool isNegative() {
    return num.real < 0;
  }

  bool isInteger() {
    if (isComplex()) return false;
    return num.real == num.real.toInt();
  }

  bool isPositiveInteger() {
    if (isComplex()) return false;
    return num.real >= 0 && isInteger();
  }

  bool isNatural() {
    if (isComplex()) return false;
    // return num.getReal().val.isNatural() != 0;
    return num.real >= 0 && isInteger();
  }

  bool isComplex() {
    // return !num.getImag().val.isZero();
    return num.imaginary != 0;
  }

  // Return error if overflow or underflow
  void checkFlags() {
    if (num.isInfinite) {
      error = 'Infinity';
    }
    else if (num.isNaN) {
      error = 'NaN';
    }
  }

  bool equals(Number y) {
    return num == y.num;
  }

  int compare(Number y) {
    return num.getReal().val.cmp(y.num.getReal().val);
  }

  Number sgn() {
    var z = Number.integer(num.getReal().val.sgn());
    return z;
  }

  Number invertSign() {
    var z = Number();
    z.num.neg(num);
    return z;
  }

  Number abs() {
    var z = Number();
    z.num.getImag().val.setZero();
    MPC.abs(z.num.getReal().val, num);
    return z;
  }

  Number arg([AngleUnit unit = AngleUnit.radians]) {
    if (isZero()) {
      // Handle zero
    }
    var z = Number();
    z.num.getImag().val.setZero();
    MPC.arg(z.num.getReal().val, num);
    mpcFromRadians(z.num, z.num, unit);
    if (!isComplex() && isNegative()) {
      // Handle negative real numbers
    }
    return z;
  }

  Number conjugate() {
    var z = Number();
    z.num.conj(num);
    return z;
  }

  Number realComponent() {
    var z = Number();
    z.num.setMpreal(num.getReal().val);
    return z;
  }

  Number imaginaryComponent() {
    var z = Number();
    z.num.setMpreal(num.getImag().val);
    return z;
  }

  Number integerComponent() {
    var z = Number();
    z.num.getImag().val.setZero();
    z.num.getReal().val.trunc(num.getReal().val);
    return z;
  }

  Number fractionalComponent() {
    var z = Number();
    z.num.getImag().val.setZero();
    z.num.getReal().val.frac(num.getReal().val);
    return z;
  }

  Number fractionalPart() {
    return subtract(floor());
  }

  Number floor() {
    var z = Number();
    z.num.getImag().val.setZero();
    z.num.getReal().val.floor(num.getReal().val);
    return z;
  }

  Number ceiling() {
    var z = Number();
    z.num.getImag().val.setZero();
    z.num.getReal().val.ceil(num.getReal().val);
    return z;
  }

  Number round() {
    var z = Number();
    z.num.getImag().val.setZero();
    z.num.getReal().val.round(num.getReal().val);
    return z;
  }

  Number reciprocal() {
    var z = Number();
    z.num.setSignedInteger(1);
    z.num.mprealDivide(z.num.getReal().val, num);
    return z;
  }

  Number epowy() {
    var z = Number();
    z.num.exp(num);
    return z;
  }

  Number xpowy(Number y) {
    if (isZero() && y.isNegative()) {
      // Handle 0^-n
    }
    if (isZero() && y.isZero()) {
      // Handle 0^0
    }
    if (!isComplex() && !y.isComplex() && !y.isInteger()) {
      // Handle non-integer exponent
    }
    var z = Number();
    z.num.power(num, y.num);
    return z;
  }

  Number xpowyInteger(int n) {
    if (isZero() && n < 0) {
      // Handle 0^-n
    }
    if (isZero() && n == 0) {
      // Handle 0^0
    }
    var z = Number();
    z.num.powerInteger(num, n);
    return z;
  }

  Number root(int n) {
    var z = Number();
    if (n < 0) {
      // Handle negative root
    } else if (n > 0) {
      // Handle positive root
    } else {
      // Handle zero root
    }
    if (!isComplex() && (!isNegative() || (n & 1) == 1)) {
      z.num.getImag().val.setZero();
    } else {
      // Handle complex root
    }
    return z;
  }

  Number sqrt() {
    return root(2);
  }

  Number ln() {
    if (isZero()) {
      // Handle ln(0)
    }
    var z = Number();
    z.num.log(num);
    if (!isComplex() && isNegative()) {
      // Handle negative real numbers
    }
    return z;
  }

  Number logarithm(int n) {
    if (isZero()) {
      // Handle log(0)
    }
    var t1 = Number.integer(n);
    return ln().divide(t1.ln());
  }

  Number factorial() {
    if (isZero()) return Number.integer(1);
    if (!isNatural()) {
      // Handle non-natural number
    }
    var value = toInteger();
    var z = this;
    for (var i = 2; i < value; i++) {
      // Handle factorial calculation
    }
    return z;
  }

  Number add(Number y) {
    var z = Number();
    z.num.add(num, y.num);
    return z;
  }

  Number subtract(Number y) {
    var z = Number();
    z.num.subtract(num, y.num);
    return z;
  }

  Number multiply(Number y) {
    var z = Number();
    z.num.multiply(num, y.num);
    return z;
  }

  Number multiplyInteger(int y) {
    var z = Number();
    z.num.multiplySignedInteger(num, y);
    return z;
  }

  Number divide(Number y) {
    if (y.isZero()) {
      // Handle division by zero
    }
    var z = Number();
    z.num.divide(num, y.num);
    return z;
  }

  Number divideInteger(int y) {
    return divide(Number.integer(y));
  }

  Number modulusDivide(Number y) {
    if (!isInteger() || !y.isInteger()) {
      // Handle non-integer modulus
    }
    var t1 = divide(y).floor();
    var t2 = t1.multiply(y);
    var z = subtract(t2);
    t1 = Number.integer(0);
    return z;
  }

  Number modularExponentiation(Number exp, Number mod) {
    // Handle modular exponentiation
  }

  Number sin([AngleUnit unit = AngleUnit.radians]) {
    // Handle sine calculation
  }

  Number cos([AngleUnit unit = AngleUnit.radians]) {
    // Handle cosine calculation
  }

  Number tan([AngleUnit unit = AngleUnit.radians]) {
    // Handle tangent calculation
  }

  Number asin([AngleUnit unit = AngleUnit.radians]) {
    // Handle arcsine calculation
  }

  Number acos([AngleUnit unit = AngleUnit.radians]) {
    // Handle arccosine calculation
  }

  Number atan([AngleUnit unit = AngleUnit.radians]) {
    // Handle arctangent calculation
  }

  Number sinh() {
    // Handle hyperbolic sine calculation
  }

  Number cosh() {
    // Handle hyperbolic cosine calculation
  }

  Number tanh() {
    // Handle hyperbolic tangent calculation
  }

  Number asinh() {
    // Handle inverse hyperbolic sine calculation
  }

  Number acosh() {
    // Handle inverse hyperbolic cosine calculation
  }

  Number atanh() {
    // Handle inverse hyperbolic tangent calculation
  }

  Number and(Number y) {
    // Handle bitwise AND
  }

  Number or(Number y) {
    // Handle bitwise OR
  }

  Number xor(Number y) {
    // Handle bitwise XOR
  }

  Number not(int wordlen) {
    // Handle bitwise NOT
  }

  Number mask(Number x, int wordlen) {
    // Handle bitwise mask
  }

  Number shift(int count) {
    // Handle bitwise shift
  }

  Number onesComplement(int wordlen) {
    // Handle ones complement
  }

  Number twosComplement(int wordlen) {
    // Handle twos complement
  }

  bool isSprp(Number p, int b) {
    // Handle strong probable prime test
  }

  bool isPrime(Number x) {
    // Handle prime test
  }

  List<Number?> factorize() {
    // Handle factorization
  }

  List<Number?> factorizeUint64(int n) {
    // Handle factorization of uint64
  }

  Number copy() {
    // Handle copy
  }

  static void mpcFromRadians(Complex res, Complex op, AngleUnit unit) {
    // Handle conversion from radians
  }

  static void mpcToRadians(Complex res, Complex op, AngleUnit unit) {
    // Handle conversion to radians
  }

  Number toRadians(AngleUnit unit) {
    // Handle conversion to radians
  }

  Number bitwise(Number y, BitwiseFunc bitwiseOperator, int wordlen) {
    // Handle bitwise operation
  }

  int hexToInt(String digit) {
    // Handle hex to int conversion
  }

  String toHexString() {
    // Handle conversion to hex string
  }
}
