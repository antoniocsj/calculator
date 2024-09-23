import 'package:calculator/enums.dart';
import 'package:calculator/mpfr.dart';
import 'package:calculator/mpc.dart';



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

  Number.double(double real, [double imag = 0]) {
    _num = Complex.fromDouble(real, imag);
  }

  Number.complex(Number r, Number i) {
    _num = Complex.fromComplex(r._num, i._num);
  }

  Number.polar(Number r, Number theta, [AngleUnit unit = AngleUnit.radians]) {
    var x = theta.cos(unit);
    var y = theta.sin(unit);
    _num = Complex.fromPolar(x.multiply(r), y.multiply(r));
  }

  Number.eulers() {
    _num = Complex.eulers();
  }

  Number.i() {
    _num = Complex.i();
  }

  Number.pi() {
    _num = Complex.pi();
  }

  Number.tau() {
    _num = Complex.tau();
  }

  Number.random() {
    _num = Complex.random();
  }

  void dispose() {
    _num.dispose();
  }

  int toInteger() {
    return _num.toInteger();
  }

  int toUnsignedInteger() {
    return _num.toUnsignedInteger();
  }

  double toFloat() {
    return _num.toFloat();
  }

  double toDouble() {
    return _num.toDouble();
  }

  bool isZero() {
    return _num.isZero();
  }

  bool isNegative() {
    return _num.isNegative();
  }

  bool isInteger() {
    return _num.isInteger();
  }

  bool isPositiveInteger() {
    return _num.isPositiveInteger();
  }

  bool isNatural() {
    return _num.isNatural();
  }

  bool isComplex() {
    return _num.isComplex();
  }

  static void checkFlags() {
    if (MPFR.isUnderflow()) {
      // Handle underflow
    } else if (MPFR.isOverflow()) {
      // Handle overflow
    }
  }

  bool equals(Number y) {
    return _num.equals(y._num);
  }

  int compare(Number y) {
    return _num.compare(y._num);
  }

  Number sgn() {
    return Number.integer(_num.sgn());
  }

  Number invertSign() {
    var z = Number();
    z._num = _num.invertSign();
    return z;
  }

  Number abs() {
    var z = Number();
    z._num = _num.abs();
    return z;
  }

  Number arg([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z._num = _num.arg(unit);
    return z;
  }

  Number conjugate() {
    var z = Number();
    z._num = _num.conjugate();
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
    Complex.mpcFromRadians(res, op, unit);
  }

  static void mpcToRadians(Complex res, Complex op, AngleUnit unit) {
    Complex.mpcToRadians(res, op, unit);
  }

  Number toRadians(AngleUnit unit) {
    return Number.fromComplex(_num.toRadians(unit));
  }

  Number bitwise(Number y, BitwiseFunc bitwiseOperator, int wordlen) {
    return Number.fromComplex(_num.bitwise(y._num, bitwiseOperator, wordlen));
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
