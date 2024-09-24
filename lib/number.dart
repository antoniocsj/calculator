import 'dart:math';
import 'package:calculator/enums.dart';
import 'package:calculator/mpfr.dart';
import 'package:calculator/mpc.dart';

typedef BitwiseFunc = int Function(int v1, int v2);

class Number {
  static int precision = 1000;
  static String? error;

  late Complex _num;

  // Getter para a precisão
  int get getPrecision => precision;

  // Setter para a precisão
  set setPrecision(int value) {
    precision = value;
  }

  // Construtor padrão
  Number() {
    _num = Complex(precision);
  }

  Number.fromInt(int real, [int imag = 0]) {
    _num = Complex.fromInt(real, imag, precision);
  }

  Number.fromUInt(int real, [int imag = 0]) {
    _num = Complex.fromUInt(real, imag, precision);
  }

  Number.fromFraction(int numerator, int denominator) {
    if (denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
    _num = Complex.fromInt(numerator, precision);
    _num.divideUInt(_num, denominator);
  }

  Number.fromReal(Real real, [Real? imag]) {
    _num = Complex.fromReal(real, imag, precision);
  }

  Number.fromDouble(double real, [double imag = 0]) {
    _num = Complex.fromDouble(real, imag, precision);
  }

  Number.fromComplex(Number r, Number i) {
    _num = Complex.fromComplex(r._num, i._num);
  }

  Number.polar(Number r, Number theta, [AngleUnit unit = AngleUnit.radians]) {
    var x = theta.cos(unit).multiply(r);
    var y = theta.sin(unit).multiply(r);
    _num = Complex.fromComplex(x._num, y._num);
  }

  // // Construtor da constante de Euler
  Number.eulers() {
    _num = Complex.eulers();
  }

  Number.i() {
    _num = Complex.fromInt(0, 1, precision);
  }

  Number.pi() {
    _num = Complex.pi();
  }

  Number.tau() {
    _num = Complex.tau();
  }

  Number.random() {
    var rnd = Random().nextDouble();
    _num = Complex.fromDouble(rnd, rnd, precision);
    // pesquisar como fazer isso usando a biblioteca mpfr e mpc.
  }

  void dispose() {
    _num.dispose();
  }

  int toInteger() {
    var rePtr = _num.getRealPointer();
    return mpfr_get_si(rePtr, MPFRRound.RNDN);
  }

  int toUnsignedInteger() {
    var rePtr = _num.getRealPointer();
    return mpfr_get_ui(rePtr, MPFRRound.RNDN);
  }

  double toFloat() {
    var rePtr = _num.getRealPointer();
    return mpfr_get_flt(rePtr, MPFRRound.RNDN);
  }

  double toDouble() {
    var rePtr = _num.getRealPointer();
    return mpfr_get_d(rePtr, MPFRRound.RNDN);
  }

  bool isZero() {
    return _num.isZero();
  }

  bool isNegative() {
    var rePtr = _num.getRealPointer();
    return mpfr_sgn(rePtr) < 0;
  }

  bool isInteger() {
    if (isComplex()) {
      return false;
    } else {
      var rePtr = _num.getRealPointer();
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
    var imPtr = _num.getImaginaryPointer();
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
    return _num.isEqual(y._num);
  }

  int compare(Number y) {
    var rePtrThis = _num.getRealPointer();
    var rePtrY = y._num.getRealPointer();
    return mpfr_cmp(rePtrThis, rePtrY);
  }

  Number sgn() {
    var rePtr = _num.getRealPointer();
    var z = Number.fromInt(mpfr_sgn(rePtr));
    return z;
  }

  Number invertSign() {
    var z = Number();
    z._num.negate(_num);
    return z;
  }

  Number abs() {
    var z = Number();
    var imPtrZ = z._num.getImaginaryPointer();
    mpfr_set_zero(imPtrZ, 1);

    var rePtrZ = z._num.getRealPointer();
    mpfr_abs(rePtrZ, _num.getRealPointer(), MPFRRound.RNDN);
    return z;
  }

  Number arg([AngleUnit unit = AngleUnit.radians]) {
    if (isZero()) {
      error = 'Argument of zero is undefined';
      return Number.fromInt(0);
    }

    var z = Number();
    var rePtrZ = z._num.getRealPointer();
    var imPtrZ = z._num.getImaginaryPointer();

    mpfr_set_zero(imPtrZ, 1);
    mpc_arg(rePtrZ, _num.getPointer(), MPFRRound.RNDN);

    mpcFromRadians(z._num, z._num, unit);
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
    z._num.conj(_num);
    return z;
  }

  Number realComponent() {
    var z = Number();
    z._num = _num.realComponent();
    return z;
  }

  Number imaginaryComponent() {
    var z = Number();
    z._num = _num.imaginaryComponent();
    return z;
  }

  Number integerComponent() {
    var z = Number();
    z._num = _num.integerComponent();
    return z;
  }

  Number fractionalComponent() {
    var z = Number();
    z._num = _num.fractionalComponent();
    return z;
  }

  Number fractionalPart() {
    return subtract(floor());
  }

  Number floor() {
    var z = Number();
    z._num = _num.floor();
    return z;
  }

  Number ceiling() {
    var z = Number();
    z._num = _num.ceiling();
    return z;
  }

  Number round() {
    var z = Number();
    z._num = _num.round();
    return z;
  }

  Number reciprocal() {
    var z = Number();
    z._num = _num.reciprocal();
    return z;
  }

  Number epowy() {
    var z = Number();
    z._num = _num.epowy();
    return z;
  }

  Number xpowy(Number y) {
    var z = Number();
    z._num = _num.xpowy(y._num);
    return z;
  }

  Number xpowyInteger(int n) {
    var z = Number();
    z._num = _num.xpowyInteger(n);
    return z;
  }

  Number root(int n) {
    var z = Number();
    z._num = _num.root(n);
    return z;
  }

  Number sqrt() {
    return root(2);
  }

  Number ln() {
    var z = Number();
    z._num = _num.ln();
    return z;
  }

  Number logarithm(int n) {
    var z = Number();
    z._num = _num.logarithm(n);
    return z;
  }

  Number factorial() {
    var z = Number();
    z._num = _num.factorial();
    return z;
  }

  Number add(Number y) {
    var z = Number();
    z._num = _num.add(y._num);
    return z;
  }

  Number subtract(Number y) {
    var z = Number();
    z._num = _num.subtract(y._num);
    return z;
  }

  Number multiply(Number y) {
    var z = Number();
    z._num = _num.multiply(y._num);
    return z;
  }

  Number multiplyInteger(int y) {
    var z = Number();
    z._num = _num.multiplyInteger(y);
    return z;
  }

  Number divide(Number y) {
    var z = Number();
    z._num = _num.divide(y._num);
    return z;
  }

  Number divideInteger(int y) {
    return divide(Number.integer(y));
  }

  Number modulusDivide(Number y) {
    var z = Number();
    z._num = _num.modulusDivide(y._num);
    return z;
  }

  Number modularExponentiation(Number exp, Number mod) {
    var z = Number();
    z._num = _num.modularExponentiation(exp._num, mod._num);
    return z;
  }

  Number sin([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.sin(unit);
    return z;
  }

  Number cos([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.cos(unit);
    return z;
  }

  Number tan([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.tan(unit);
    return z;
  }

  Number asin([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.asin(unit);
    return z;
  }

  Number acos([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.acos(unit);
    return z;
  }

  Number atan([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.atan(unit);
    return z;
  }

  Number sinh() {
    var z = Number();
    z._num = _num.sinh();
    return z;
  }

  Number cosh() {
    var z = Number();
    z._num = _num.cosh();
    return z;
  }

  Number tanh() {
    var z = Number();
    z._num = _num.tanh();
    return z;
  }

  Number asinh() {
    var z = Number();
    z._num = _num.asinh();
    return z;
  }

  Number acosh() {
    var z = Number();
    z._num = _num.acosh();
    return z;
  }

  Number atanh() {
    var z = Number();
    z._num = _num.atanh();
    return z;
  }

  Number and(Number y) {
    var z = Number();
    z._num = _num.and(y._num);
    return z;
  }

  Number or(Number y) {
    var z = Number();
    z._num = _num.or(y._num);
    return z;
  }

  Number xor(Number y) {
    var z = Number();
    z._num = _num.xor(y._num);
    return z;
  }

  Number not(int wordlen) {
    var z = Number();
    z._num = _num.not(wordlen);
    return z;
  }

  Number mask(Number x, int wordlen) {
    var z = Number();
    z._num = _num.mask(x._num, wordlen);
    return z;
  }

  Number shift(int count) {
    var z = Number();
    z._num = _num.shift(count);
    return z;
  }

  Number onesComplement(int wordlen) {
    var z = Number();
    z._num = _num.onesComplement(wordlen);
    return z;
  }

  Number twosComplement(int wordlen) {
    var z = Number();
    z._num = _num.twosComplement(wordlen);
    return z;
  }

  bool isSprp(Number p, int b) {
    return _num.isSprp(p._num, b);
  }

  bool isPrime(Number x) {
    return _num.isPrime(x._num);
  }

  List<Number> factorize() {
    return _num.factorize().map((e) => Number.fromComplex(e)).toList();
  }

  List<Number> factorizeUint64(int n) {
    return _num.factorizeUint64(n).map((e) => Number.fromComplex(e)).toList();
  }

  Number copy() {
    return Number.fromComplex(_num.copy());
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
    mpcToRadians(z._num, _num, unit);
    return z;
  }

  Number bitwise(Number y, BitwiseFunc bitwiseOperator, int wordlen) {

  }

  int hexToInt(String digit) {
    return _num.hexToInt(digit);
  }

  String toHexString() {
    return _num.toHexString();
  }

  static int parseLiteralPrefix(String str, int prefixLen) {
    return Number.parseLiteralPrefix(str, prefixLen);
  }

  Number? mpSetFromString(String str, [int defaultBase = 10, bool mayHavePrefix = true]) {
    return Number.fromComplex(_num.mpSetFromString(str, defaultBase, mayHavePrefix));
  }

  int charVal(String c, int numberBase) {
    return _num.charVal(c, numberBase);
  }

  Number? setFromSexagesimal(String str) {
    return Number.fromComplex(_num.setFromSexagesimal(str));
  }

  bool mpIsOverflow(Number x, int wordlen) {
    return _num.mpIsOverflow(x._num, wordlen);
  }
}
