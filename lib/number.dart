import 'package:calculator/enums.dart';
import 'package:calculator/mpc.dart';



class Number {
  static int precision = 1000;
  static String? error;

  late Complex num;

  Number.integer(int real, [int imag = 0]) {
    num = Complex.fromInt(real, imag);
  }

  Number.unsignedInteger(int real, [int imag = 0]) {
    num = Complex.fromUnsignedInt(real, imag);
  }

  Number.fraction(int numerator, int denominator) {
    if (denominator < 0) {
      // Handle negative denominator
    }
    num = Complex.fromFraction(numerator, denominator);
  }

  Number.mpreal(MPFRReal real, [MPFRReal? imag]) {
    num = Complex.fromMPReal(real, imag);
  }

  Number.double(double real, [double imag = 0]) {
    num = Complex.fromDouble(real, imag);
  }

  Number.complex(Number r, Number i) {
    num = Complex.fromComplex(r.num, i.num);
  }

  Number.polar(Number r, Number theta, [AngleUnit unit = AngleUnit.radians]) {
    var x = theta.cos(unit);
    var y = theta.sin(unit);
    num = Complex.fromPolar(x.multiply(r), y.multiply(r));
  }

  Number.eulers() {
    num = Complex.eulers();
  }

  Number.i() {
    num = Complex.i();
  }

  Number.pi() {
    num = Complex.pi();
  }

  Number.tau() {
    num = Complex.tau();
  }

  Number.random() {
    num = Complex.random();
  }

  int toInteger() {
    return num.toInteger();
  }

  int toUnsignedInteger() {
    return num.toUnsignedInteger();
  }

  double toFloat() {
    return num.toFloat();
  }

  double toDouble() {
    return num.toDouble();
  }

  bool isZero() {
    return num.isZero();
  }

  bool isNegative() {
    return num.isNegative();
  }

  bool isInteger() {
    return num.isInteger();
  }

  bool isPositiveInteger() {
    return num.isPositiveInteger();
  }

  bool isNatural() {
    return num.isNatural();
  }

  bool isComplex() {
    return num.isComplex();
  }

  static void checkFlags() {
    if (MPFR.isUnderflow()) {
      // Handle underflow
    } else if (MPFR.isOverflow()) {
      // Handle overflow
    }
  }

  bool equals(Number y) {
    return num.equals(y.num);
  }

  int compare(Number y) {
    return num.compare(y.num);
  }

  Number sgn() {
    return Number.integer(num.sgn());
  }

  Number invertSign() {
    var z = Number();
    z.num = num.invertSign();
    return z;
  }

  Number abs() {
    var z = Number();
    z.num = num.abs();
    return z;
  }

  Number arg([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.arg(unit);
    return z;
  }

  Number conjugate() {
    var z = Number();
    z.num = num.conjugate();
    return z;
  }

  Number realComponent() {
    var z = Number();
    z.num = num.realComponent();
    return z;
  }

  Number imaginaryComponent() {
    var z = Number();
    z.num = num.imaginaryComponent();
    return z;
  }

  Number integerComponent() {
    var z = Number();
    z.num = num.integerComponent();
    return z;
  }

  Number fractionalComponent() {
    var z = Number();
    z.num = num.fractionalComponent();
    return z;
  }

  Number fractionalPart() {
    return subtract(floor());
  }

  Number floor() {
    var z = Number();
    z.num = num.floor();
    return z;
  }

  Number ceiling() {
    var z = Number();
    z.num = num.ceiling();
    return z;
  }

  Number round() {
    var z = Number();
    z.num = num.round();
    return z;
  }

  Number reciprocal() {
    var z = Number();
    z.num = num.reciprocal();
    return z;
  }

  Number epowy() {
    var z = Number();
    z.num = num.epowy();
    return z;
  }

  Number xpowy(Number y) {
    var z = Number();
    z.num = num.xpowy(y.num);
    return z;
  }

  Number xpowyInteger(int n) {
    var z = Number();
    z.num = num.xpowyInteger(n);
    return z;
  }

  Number root(int n) {
    var z = Number();
    z.num = num.root(n);
    return z;
  }

  Number sqrt() {
    return root(2);
  }

  Number ln() {
    var z = Number();
    z.num = num.ln();
    return z;
  }

  Number logarithm(int n) {
    var z = Number();
    z.num = num.logarithm(n);
    return z;
  }

  Number factorial() {
    var z = Number();
    z.num = num.factorial();
    return z;
  }

  Number add(Number y) {
    var z = Number();
    z.num = num.add(y.num);
    return z;
  }

  Number subtract(Number y) {
    var z = Number();
    z.num = num.subtract(y.num);
    return z;
  }

  Number multiply(Number y) {
    var z = Number();
    z.num = num.multiply(y.num);
    return z;
  }

  Number multiplyInteger(int y) {
    var z = Number();
    z.num = num.multiplyInteger(y);
    return z;
  }

  Number divide(Number y) {
    var z = Number();
    z.num = num.divide(y.num);
    return z;
  }

  Number divideInteger(int y) {
    return divide(Number.integer(y));
  }

  Number modulusDivide(Number y) {
    var z = Number();
    z.num = num.modulusDivide(y.num);
    return z;
  }

  Number modularExponentiation(Number exp, Number mod) {
    var z = Number();
    z.num = num.modularExponentiation(exp.num, mod.num);
    return z;
  }

  Number sin([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.sin(unit);
    return z;
  }

  Number cos([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.cos(unit);
    return z;
  }

  Number tan([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.tan(unit);
    return z;
  }

  Number asin([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.asin(unit);
    return z;
  }

  Number acos([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.acos(unit);
    return z;
  }

  Number atan([AngleUnit unit = AngleUnit.radians]) {
    var z = Number();
    z.num = num.atan(unit);
    return z;
  }

  Number sinh() {
    var z = Number();
    z.num = num.sinh();
    return z;
  }

  Number cosh() {
    var z = Number();
    z.num = num.cosh();
    return z;
  }

  Number tanh() {
    var z = Number();
    z.num = num.tanh();
    return z;
  }

  Number asinh() {
    var z = Number();
    z.num = num.asinh();
    return z;
  }

  Number acosh() {
    var z = Number();
    z.num = num.acosh();
    return z;
  }

  Number atanh() {
    var z = Number();
    z.num = num.atanh();
    return z;
  }

  Number and(Number y) {
    var z = Number();
    z.num = num.and(y.num);
    return z;
  }

  Number or(Number y) {
    var z = Number();
    z.num = num.or(y.num);
    return z;
  }

  Number xor(Number y) {
    var z = Number();
    z.num = num.xor(y.num);
    return z;
  }

  Number not(int wordlen) {
    var z = Number();
    z.num = num.not(wordlen);
    return z;
  }

  Number mask(Number x, int wordlen) {
    var z = Number();
    z.num = num.mask(x.num, wordlen);
    return z;
  }

  Number shift(int count) {
    var z = Number();
    z.num = num.shift(count);
    return z;
  }

  Number onesComplement(int wordlen) {
    var z = Number();
    z.num = num.onesComplement(wordlen);
    return z;
  }

  Number twosComplement(int wordlen) {
    var z = Number();
    z.num = num.twosComplement(wordlen);
    return z;
  }

  bool isSprp(Number p, int b) {
    return num.isSprp(p.num, b);
  }

  bool isPrime(Number x) {
    return num.isPrime(x.num);
  }

  List<Number> factorize() {
    return num.factorize().map((e) => Number.fromComplex(e)).toList();
  }

  List<Number> factorizeUint64(int n) {
    return num.factorizeUint64(n).map((e) => Number.fromComplex(e)).toList();
  }

  Number copy() {
    return Number.fromComplex(num.copy());
  }

  static void mpcFromRadians(Complex res, Complex op, AngleUnit unit) {
    Complex.mpcFromRadians(res, op, unit);
  }

  static void mpcToRadians(Complex res, Complex op, AngleUnit unit) {
    Complex.mpcToRadians(res, op, unit);
  }

  Number toRadians(AngleUnit unit) {
    return Number.fromComplex(num.toRadians(unit));
  }

  Number bitwise(Number y, BitwiseFunc bitwiseOperator, int wordlen) {
    return Number.fromComplex(num.bitwise(y.num, bitwiseOperator, wordlen));
  }

  int hexToInt(String digit) {
    return num.hexToInt(digit);
  }

  String toHexString() {
    return num.toHexString();
  }

  static int parseLiteralPrefix(String str, int prefixLen) {
    return Number.parseLiteralPrefix(str, prefixLen);
  }

  Number? mpSetFromString(String str, [int defaultBase = 10, bool mayHavePrefix = true]) {
    return Number.fromComplex(num.mpSetFromString(str, defaultBase, mayHavePrefix));
  }

  int charVal(String c, int numberBase) {
    return num.charVal(c, numberBase);
  }

  Number? setFromSexagesimal(String str) {
    return Number.fromComplex(num.setFromSexagesimal(str));
  }

  bool mpIsOverflow(Number x, int wordlen) {
    return num.mpIsOverflow(x.num, wordlen);
  }
}
