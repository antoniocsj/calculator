import 'dart:math';
import 'package:calculator/enums.dart';
import 'package:calculator/mpfr.dart';
import 'package:calculator/mpc.dart';

typedef BitwiseFunc = int Function(int v1, int v2);

class Number {
  static int precision = 1000;
  static String? error;

  late Complex num;

  // Getter para a precisão
  int get getPrecision => precision;

  // Setter para a precisão
  set setPrecision(int value) {
    precision = value;
  }

  // Construtor padrão
  Number() {
    num = Complex(precision);
  }

  Number.fromInt(int real, [int imag = 0]) {
    num = Complex.fromInt(real, imag, precision);
  }

  Number.fromUInt(int real, [int imag = 0]) {
    num = Complex.fromUInt(real, imag, precision);
  }

  Number.fromFraction(int numerator, int denominator) {
    if (denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
    num = Complex.fromInt(numerator, precision);
    num.divideUInt(num, denominator);
  }

  Number.fromReal(Real real, [Real? imag]) {
    num = Complex.fromReal(real, imag, precision);
  }

  Number.fromDouble(double real, [double imag = 0]) {
    num = Complex.fromDouble(real, imag, precision);
  }

  Number.fromComplex(Number r, Number i) {
    num = Complex.fromComplex(r.num, i.num);
  }

  Number.polar(Number r, Number theta, [AngleUnit unit = AngleUnit.radians]) {
    var x = theta.cos(unit).multiply(r);
    var y = theta.sin(unit).multiply(r);
    num = Complex.fromComplex(x.num, y.num);
  }

  // // Construtor da constante de Euler
  Number.eulers() {
    num = Complex.eulers();
  }

  Number.i() {
    num = Complex.fromInt(0, 1, precision);
  }

  Number.pi() {
    num = Complex.pi();
  }

  Number.tau() {
    num = Complex.tau();
  }

  Number.random() {
    var rnd = Random().nextDouble();
    num = Complex.fromDouble(rnd, rnd, precision);
    // pesquisar como fazer isso usando a biblioteca mpfr e mpc.
  }

  void dispose() {
    num.dispose();
  }

  int toInteger() {
    var rePtr = num.getRealPointer();
    return mpfr_get_si(rePtr, MPFRRound.RNDN);
  }

  int toUnsignedInteger() {
    var rePtr = num.getRealPointer();
    return mpfr_get_ui(rePtr, MPFRRound.RNDN);
  }

  double toFloat() {
    var rePtr = num.getRealPointer();
    return mpfr_get_flt(rePtr, MPFRRound.RNDN);
  }

  double toDouble() {
    var rePtr = num.getRealPointer();
    return mpfr_get_d(rePtr, MPFRRound.RNDN);
  }

  bool isZero() {
    return num.isZero();
  }

  bool isNegative() {
    var rePtr = num.getRealPointer();
    return mpfr_sgn(rePtr) < 0;
  }

  bool isInteger() {
    if (isComplex()) {
      return false;
    } else {
      var rePtr = num.getRealPointer();
      return mpfr_integer_p(rePtr) != 0;
    }
  }

  bool isPositiveInteger() {
    return isInteger() && !isNegative();
  }

  bool isNatural() {
    return isPositiveInteger();
  }

  // return true if the number has an imaginary part
  bool isComplex() {
    var imPtr = num.getImaginaryPointer();
    return mpfr_zero_p(imPtr) == 0;
  }

  // Return error if overflow or underflow
  static void checkFlags() {
    if (mpfr_overflow_p() != 0) {
      error = 'Overflow';
    } else if (mpfr_underflow_p() != 0) {
      error = 'Underflow';
    }
  }

  bool equals(Number y) {
    return num.isEqual(y.num);
  }

  int compare(Number y) {
    var rePtrThis = num.getRealPointer();
    var rePtrY = y.num.getRealPointer();
    return mpfr_cmp(rePtrThis, rePtrY);
  }

  Number sgn() {
    var rePtr = num.getRealPointer();
    var z = Number.fromInt(mpfr_sgn(rePtr));
    return z;
  }

  Number invertSign() {
    var z = Number();
    z.num.negate(num);
    return z;
  }

  Number abs() {
    var z = Number();
    var imPtrZ = z.num.getImaginaryPointer();
    mpfr_set_zero(imPtrZ, 1);

    var rePtrZ = z.num.getRealPointer();
    mpfr_abs(rePtrZ, num.getRealPointer(), MPFRRound.RNDN);
    return z;
  }

  Number arg([AngleUnit unit = AngleUnit.radians]) {
    if (isZero()) {
      error = 'Argument of zero is undefined';
      return Number.fromInt(0);
    }

    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    mpfr_set_zero(imPtrZ, 1);
    mpc_arg(rePtrZ, num.getPointer(), MPFRRound.RNDN);

    mpcFromRadians(z.num, z.num, unit);
    // MPC returns -π for the argument of negative real numbers if
    // their imaginary part is -0 (which it is in the numbers
    // created by test-equation), we want +π for all real negative
    // numbers

    if (!isComplex() && isNegative()) {
      mpfr_abs(rePtrZ, rePtrZ, MPFRRound.RNDN);
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
    z.num.setMPReal(num.getRealPointer());
    return z;
  }

  Number imaginaryComponent() {
    // Copy imaginary component to real component
    var z = Number();
    z.num.setMPReal(num.getImaginaryPointer());
    return z;
  }

  Number integerComponent() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr_set_zero(imPtrZ, 1);

    // truncate the real part of z to an integer
    mpfr_trunc(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = x mod 1
  Number fractionalComponent() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the fractional part of the real part of this
    mpfr_frac(rePtrZ, num.getRealPointer(), MPFRRound.RNDN);

    return z;
  }

  /* Returns z = {x} */
  Number fractionalPart() {
    // return subtract(floor());
  }

  // Returns z = ⌊x⌋
  Number floor() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the floor of the real part of this
    mpfr_floor(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = ⌈x⌉
  Number ceiling() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the ceiling of the real part of this
    mpfr_ceil(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = [x]
  Number round() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the round of the real part of this
    mpfr_round(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = 1 / x
  Number reciprocal() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();

    // set z to (1, 0)
    z.num.setInt(1);

    // divide z by this
    z.num.mpRealDivide(rePtrZ, num.getPointer());

    return z;
  }

  // Sets z = e^x
  Number epowy() {
    var z = Number();
    z.num.exp(num);
    return z;
  }

  // Sets z = x^y
  Number xpowy(Number y) {
    // 0^-n invalid */
    if (isZero() && y.isNegative()) {
      error = '0^(-n) is undefined';
      return Number.fromInt(0);
    }

    // 0^0 is indeterminate
    if (isZero() && y.isZero()) {
      error = '0^0 is indeterminate';
      return Number.fromInt(0);
    }

    if (!isComplex() && !y.isComplex() && !y.isInteger()) {
      var reciprocal = y.reciprocal();
      if (reciprocal.isInteger()) {
        return root(reciprocal.toInteger());
      }
    }

    var z = Number();
    z.num.power(num, y.num);
    return z;
  }

  // Sets z = x^y
  Number xpowyInteger(int n) {
    // 0^-n invalid
    if (isZero() && n < 0) {
      error = '0^(-n) is undefined';
      return Number.fromInt(0);
    }

    // 0^0 is indeterminate
    if (isZero() && n == 0) {
      error = '0^0 is indeterminate';
      return Number.fromInt(0);
    }

    var z = Number();
    z.num.powerInt(num, n);
    return z;
  }

  Number root(int n) {
  }

  Number sqrt() {
  }

  Number ln() {
  }

  Number logarithm(int n) {
  }

  Number factorial() {
  }

  Number add(Number y) {
  }

  Number subtract(Number y) {
  }

  Number multiply(Number y) {
  }

  Number multiplyInteger(int y) {
  }

  Number divide(Number y) {
  }

  Number divideInteger(int y) {
  }

  Number modulusDivide(Number y) {
  }

  Number modularExponentiation(Number exp, Number mod) {
  }

  Number sin([AngleUnit unit = AngleUnit.radians]) {
  }

  Number cos([AngleUnit unit = AngleUnit.radians]) {
  }

  Number tan([AngleUnit unit = AngleUnit.radians]) {
  }

  Number asin([AngleUnit unit = AngleUnit.radians]) {
  }

  Number acos([AngleUnit unit = AngleUnit.radians]) {
  }

  Number atan([AngleUnit unit = AngleUnit.radians]) {
  }

  Number sinh() {
  }

  Number cosh() {
  }

  Number tanh() {
  }

  Number asinh() {
  }

  Number acosh() {
  }

  Number atanh() {
  }

  Number and(Number y) {
  }

  Number or(Number y) {
  }

  Number xor(Number y) {
  }

  Number not(int wordlen) {
  }

  Number mask(Number x, int wordlen) {
  }

  Number shift(int count) {
  }

  Number onesComplement(int wordlen) {
  }

  Number twosComplement(int wordlen) {
  }

  bool isSprp(Number p, int b) {
  }

  bool isPrime(Number x) {
  }

  List<Number> factorize() {
  }

  List<Number> factorizeUint64(int n) {
  }

  Number copy() {
  }

  static void mpcFromRadians(Complex res, Complex op, AngleUnit unit) {
    int i;

    switch (unit) {
      case AngleUnit.radians:
        if (res != op) {
          res.setComplex(op);
        }
        return;

      case AngleUnit.degrees:
        i = 180;
        break;

      case AngleUnit.gradians:
        i = 200;
        break;

      default:
        return;
    }

    var scale = Real(precision);
    scale.setPi();
    scale.intDiv(i, scale);
    res.multiplyReal(op, scale);

    scale.dispose();
  }

  static void mpcToRadians(Complex res, Complex op, AngleUnit unit) {
    int i;

    switch (unit) {
      case AngleUnit.radians:
        if (res != op) {
          res.setComplex(op);
        }
        return;

      case AngleUnit.degrees:
        i = 180;
        break;

      case AngleUnit.gradians:
        i = 200;
        break;

      default:
        return;
    }

    var scale = Real(precision);
    scale.setPi();
    scale.divInt(scale, i);
    res.multiplyReal(op, scale);

    scale.dispose();
  }

  Number toRadians(AngleUnit unit) {
    var z = Number();
    mpcToRadians(z.num, num, unit);
    return z;
  }

  Number bitwise(Number y, BitwiseFunc bitwiseOperator, int wordlen) {

  }

  int hexToInt(String digit) {
  }

  String toHexString() {
  }

  static int parseLiteralPrefix(String str, int prefixLen) {
  }

  Number? mpSetFromString(String str, [int defaultBase = 10, bool mayHavePrefix = true]) {
  }

  int charVal(String c, int numberBase) {
  }

  Number? setFromSexagesimal(String str) {
  }

  bool mpIsOverflow(Number x, int wordlen) {
  }
}
