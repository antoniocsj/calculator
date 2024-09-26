import 'dart:math';
import 'package:calculator/enums.dart';
import 'package:calculator/mpfr.dart';
import 'package:calculator/mpfr_bindings.dart';
import 'package:calculator/mpc.dart';
// import 'package:calculator/mpc_bindings.dart';

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
    return mpfr.mpfr_get_si(rePtr, mpfr_rnd_t.MPFR_RNDN);
  }

  int toUnsignedInteger() {
    var rePtr = num.getRealPointer();
    return mpfr.mpfr_get_ui(rePtr, mpfr_rnd_t.MPFR_RNDN);
  }

  double toFloat() {
    var rePtr = num.getRealPointer();
    return mpfr.mpfr_get_flt(rePtr, mpfr_rnd_t.MPFR_RNDN);
  }

  double toDouble() {
    var rePtr = num.getRealPointer();
    return mpfr.mpfr_get_d(rePtr, mpfr_rnd_t.MPFR_RNDN);
  }

  bool isZero() {
    return num.isZero();
  }

  bool isNegative() {
    var rePtr = num.getRealPointer();
    return mpfr.mpfr_sgn(rePtr) < 0;
  }

  bool isInteger() {
    if (isComplex()) {
      return false;
    } else {
      var rePtr = num.getRealPointer();
      return mpfr.mpfr_integer_p(rePtr) != 0;
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
    return mpfr.mpfr_zero_p(imPtr) == 0;
  }

  // Return error if overflow or underflow
  static void checkFlags() {
    if (mpfr.mpfr_overflow_p() != 0) {
      error = 'Overflow';
    } else if (mpfr.mpfr_underflow_p() != 0) {
      error = 'Underflow';
    }
  }

  bool equals(Number y) {
    return num.isEqual(y.num);
  }

  int compare(Number y) {
    var rePtrThis = num.getRealPointer();
    var rePtrY = y.num.getRealPointer();
    return mpfr.mpfr_cmp(rePtrThis, rePtrY);
  }

  Number sgn() {
    var rePtr = num.getRealPointer();
    var z = Number.fromInt(mpfr.mpfr_sgn(rePtr));
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
    mpfr.mpfr_set_zero(imPtrZ, 1);

    var rePtrZ = z.num.getRealPointer();
    mpfr.mpfr_abs(rePtrZ, num.getRealPointer(), mpfr_rnd_t.MPFR_RNDN);
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

    mpfr.mpfr_set_zero(imPtrZ, 1);
    mpc.mpc_arg(rePtrZ, num.getPointer(), mpfr_rnd_t.MPFR_RNDN);

    mpcFromRadians(z.num, z.num, unit);
    // MPC returns -π for the argument of negative real numbers if
    // their imaginary part is -0 (which it is in the numbers
    // created by test-equation), we want +π for all real negative
    // numbers

    if (!isComplex() && isNegative()) {
      mpfr.mpfr_abs(rePtrZ, rePtrZ, mpfr_rnd_t.MPFR_RNDN);
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
    mpfr.mpfr_set_zero(imPtrZ, 1);

    // truncate the real part of z to an integer
    mpfr.mpfr_trunc(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = x mod 1
  Number fractionalComponent() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr.mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the fractional part of the real part of this
    mpfr.mpfr_frac(rePtrZ, num.getRealPointer(), mpfr_rnd_t.MPFR_RNDN);

    return z;
  }

  /* Returns z = {x} */
  Number fractionalPart() {

  }

  // Returns z = ⌊x⌋
  Number floor() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr.mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the floor of the real part of this
    mpfr.mpfr_floor(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = ⌈x⌉
  Number ceiling() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr.mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the ceiling of the real part of this
    mpfr.mpfr_ceil(rePtrZ, num.getRealPointer());

    return z;
  }

  // Returns z = [x]
  Number round() {
    var z = Number();
    var rePtrZ = z.num.getRealPointer();
    var imPtrZ = z.num.getImaginaryPointer();

    // set the imaginary part of z to zero
    mpfr.mpfr_set_zero(imPtrZ, 1);

    // set the real part of z to the round of the real part of this
    mpfr.mpfr_round(rePtrZ, num.getRealPointer());

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

  // Returns z = e^x
  Number epowy() {
    var z = Number();
    z.num.exp(num);
    return z;
  }

  // Returns z = x^y
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

  // Returns z = x^y
  Number xpowyInteger(int n) {
    // 0^-n is invalid
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

  // Returns z = n√x
  Number root(int n) {
    int p;

    var z = Number();
    if (n == 0) {
      error = '0√x is undefined';
      return Number.fromInt(0);
    }
    else if (n < 0) {
      // n√x = 1 / n√(1/x)
      z.num.uIntDivide(1, num);
      p = -n;
    }
    else {
      z.num.setComplex(num);
      p = n;
    }

    if (!isComplex() && (!isNegative() || p % 2 == 1)) {
      // If x is real and non-negative or n is odd, we can take the real version of the nth root
      var rePtrZ = z.num.getRealPointer();
      var imPtrZ = z.num.getImaginaryPointer();

      mpfr.mpfr_root(rePtrZ, rePtrZ, p, mpfr_rnd_t.MPFR_RNDN);
      mpfr.mpfr_set_zero(imPtrZ, 1);
    }
    else {
      // If x is complex or negative and n is even, we can't take the real version of the nth root
      // but we can take the complex version of the nth root using the function mpc_root
      var tmp = Real(precision);

      tmp.setUInt(p);
      tmp.uintDiv(1, tmp);

      z.num.powerReal(z.num, tmp);
    }

    return z;
  }

  // Returns z = √x
  Number sqrt() {
    return root(2);
  }

  // Returns z = ln x
  Number ln() {
    // ln(0) is undefined
    if (isZero()) {
      error = 'ln(0) is undefined';
      return Number.fromInt(0);
    }

    var z = Number();
    z.num.log(num);

    // MPC returns -π for the imaginary part of the log of
    // negative real numbers if their imaginary part is -0 (which
    // it is in the numbers created by test-equation), we want +π
    // for all real negative numbers
    if (!isComplex() && isNegative()) {
      var imPtrZ = z.num.getImaginaryPointer();
      mpfr.mpfr_abs(imPtrZ, imPtrZ, mpfr_rnd_t.MPFR_RNDN);
    }

    return z;
  }

  /* Returns z = log_n x */
  Number logarithm(int n) {
    // log_n(0) is undefined
    if (isZero()) {
      error = 'log_n(0) is undefined';
      return Number.fromInt(0);
    }

    // log_n(x) = ln(x) / ln(n)
    var z = Number.fromInt(n);
    return ln().divide(z.ln());
  }

  /* Returns z = x! */
  Number factorial() {
    // 0! = 1
    if (isZero()) {
      return Number.fromInt(1);
    }

    if (!isNatural()) {

      // Factorial Not defined for Complex or for negative numbers
      if (isNegative() || isComplex()) {
        error = 'Factorial not defined for negative numbers or complex numbers';
        return Number.fromInt(0);
      }

      // Factorial(x) = Γ(x + 1)
      var tmp = add(Number.fromInt(1));
      var tmp2 = Real(precision);
      tmp2.gammaPtr(tmp.num.getRealPointer());

      return Number.fromReal(tmp2);
    }

    // Convert to integer - if couldn't be converted then the factorial would be too big anyway
    var value = toInteger();
    var z = Number.fromInt(value);

    // Factorial(x) = x! = x * (x - 1) * (x - 2) * ... * 1
    for (var i = 2; i < value; i++) {
      z = z.multiplyInteger(i);
    }

    return z;
  }

  // Returns z = x + y
  Number add(Number y) {
    var z = Number();
    z.num.add(num, y.num);
    return z;
  }

  // Returns z = x - y
  Number subtract(Number y) {
    var z = Number();
    z.num.subtract(num, y.num);
    return z;
  }

  // Returns z = x × y
  Number multiply(Number y) {
    var z = Number();
    z.num.multiply(num, y.num);
    return z;
  }

  // Returns z = x × y
  Number multiplyInteger(int y) {
    var z = Number();
    z.num.multiplyInt(num, y);
    return z;
  }

  // Returns z = x ÷ y
  Number divide(Number y) {
    if (y.isZero()) {
      error = 'Division by zero';
      return Number.fromInt(0);
    }

    var z = Number();
    z.num.divide(num, y.num);
    return z;
  }

  // Returns z = x ÷ y
  Number divideInteger(int y) {
    return divide(Number.fromInt(y));
  }

  // Sets z = x mod y
  Number modulusDivide(Number y) {
    if (!isInteger() || !y.isInteger()) {
      error = 'Modulus division is only defined for integers';
      return Number.fromInt(0);
    }

    var t1 = divide(y).floor();
    var t2 = t1.multiply(y);
    var z = subtract(t2);

    t1 = Number.fromInt(0);
    if ((y.compare(t1) < 0 && z.compare(t1) > 0) || (y.compare(t1) > 0 && z.compare(t1) < 0)) {
      z = z.add(y);
    }

    return z;
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
