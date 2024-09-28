import 'package:calculator/number.dart';
import 'package:calculator/types.dart';

enum DisplayFormat {
  AUTOMATIC,
  FIXED,
  SCIENTIFIC,
  ENGINEERING
}

class Serializer {
  late int leadingDigits; // Number of digits to show before radix
  int trailingDigits; // Number of digits to show after radix
  DisplayFormat format; // Number display mode
  late bool showTsep; // Set if the thousands separator should be shown
  late bool showZeroes; // Set if trailing zeroes should be shown

  int numberBase; // Numeric base
  late int representationBase; // Representation base

  late String radix; // Locale specific radix string
  late String tsep; // Locale specific thousands separator
  late int tsepCount; // Number of digits between separator

  // is set when an error (for example precision error while converting) occurs
  String? error;

  Serializer(this.format, this.numberBase, this.trailingDigits) {
    // Initialize locale specific radix and thousands separator
    radix = '.'; // Default radix
    tsep = ' '; // Default thousands separator
    tsepCount = 3;

    representationBase = numberBase;
    leadingDigits = 12;
    showZeroes = false;
    showTsep = false;
  }

  String serialize(Number x) {
    // For base conversion equation, use FIXED format
    if (representationBase != numberBase) {
      // Handle base conversion
    }

    switch (format) {
      case DisplayFormat.AUTOMATIC:
      // Handle automatic format
        break;
      case DisplayFormat.FIXED:
        return _castToString(x);
      case DisplayFormat.SCIENTIFIC:
      // Handle scientific format
        break;
      case DisplayFormat.ENGINEERING:
      // Handle engineering format
        break;
    }
    return '';
  }

  Number? fromString(String str) {
    // FIXME: Move mpSetFromString into here
    return Number().mpSetFromString(str, numberBase);
  }

  void setBase(int numberBase) {
    this.numberBase = numberBase;
  }

  int getBase() {
    return numberBase;
  }

  void setRepresentationBase(int representationBase) {
    this.representationBase = representationBase;
  }

  int getRepresentationBase() {
    return representationBase;
  }

  void setRadix(String radix) {
    this.radix = radix;
  }

  String getRadix() {
    return radix;
  }

  void setThousandsSeparator(String separator) {
    tsep = separator;
  }

  String getThousandsSeparator() {
    return tsep;
  }

  int getThousandsSeparatorCount() {
    return tsepCount;
  }

  void setThousandsSeparatorCount(int count) {
    tsepCount = count;
  }

  void setShowThousandsSeparators(bool visible) {
    showTsep = visible;
  }

  bool getShowThousandsSeparators() {
    return showTsep;
  }

  void setShowTrailingZeroes(bool visible) {
    showZeroes = visible;
  }

  bool getShowTrailingZeroes() {
    return showZeroes;
  }

  int getLeadingDigits() {
    return leadingDigits;
  }

  void setLeadingDigits(int leadingDigits) {
    this.leadingDigits = leadingDigits;
  }

  int getTrailingDigits() {
    return trailingDigits;
  }

  void setTrailingDigits(int trailingDigits) {
    this.trailingDigits = trailingDigits;
  }

  DisplayFormat getNumberFormat() {
    return format;
  }

  void setNumberFormat(DisplayFormat format) {
    this.format = format;
  }

  String _castToString(Number x, RefInt nDigits) {
    var string = StringBuilder();

    var xReal = x.realComponent();
    _castToStringReal(xReal, representationBase, false, nDigits, string);
    if (x.isComplex()) {
      // Handle complex number formatting
    }

    return string.toString();
  }

  void _castToStringReal(Number x, int numberBase, bool forceSign, RefInt nDigits, StringBuilder string) {
    var digits = "0123456789ABCDEF".split('');

    var number = x;
    if (number.isNegative()) {
      number = number.abs();
    }

    // Add rounding factor
    var temp = Number.fromInt(numberBase);
    temp = temp.xpowyInteger(-(trailingDigits + 1));
    temp = temp.multiplyInteger(numberBase);
    temp = temp.divideInteger(2);
    var roundedNumber = number.add(temp);

    // Write out the integer component least significant digit to most
    temp = roundedNumber.floor();
    int i = 0;

    do {
      if (numberBase == 10 && showTsep && i == tsepCount) {
        string.prepend(tsep);
        i = 0;
      }
      i++;

      var t = temp.divideInteger(numberBase);
      t = t.floor();
      var t2 = t.multiplyInteger(numberBase);
      var t3 = temp.subtract(t2);
      var d = t3.toInteger();

      if (d < 16 && d >= 0) {
        string.prepend(digits[d]);
      } else {
        // Handle error
        string.prepend('?');
        error = "Overflow: the result couldn’t be calculated";
        string.assign(error!);
        break;
      }

      nDigits.value++;
      temp = t;
    } while (!temp.isZero());

    var lastNonZero = string.length;

    string.append(radix);

    // Write out the fractional component
    temp = roundedNumber.fractionalComponent();
    for (i = 0; i < trailingDigits; i++) {
      if (temp.isZero()) {
        break;
      }

      temp = temp.multiplyInteger(numberBase);
      var digit = temp.floor();
      var d = digit.toInteger();

      string.append(digits[d]);

      if (d != 0) {
        lastNonZero = string.length;
      }

      temp = temp.subtract(digit);
    }

    // Strip trailing zeroes
    if (!showZeroes || trailingDigits == 0) {
      // Truncar a string para os primeiros 'lastNonZero' caracteres
      string.truncate(lastNonZero);
    }

    // Add sign on non-zero values
    if (string.toString() != '0' || forceSign) {
      if (x.isNegative()) {
        string.prepend('-');
      } else {
        string.prepend('+');
      }
    }

    // Append base suffix if not in default base
    if (numberBase != this.numberBase) {
      const List<String> subDigits = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
      int multiplier = 1;
      int b = numberBase;

      while (numberBase / multiplier != 0) {
        multiplier *= 10;
      }

      while (multiplier != 1) {
        multiplier ~/= 10;
        int d = b ~/ multiplier;
        b -= d * multiplier;
        string.append(subDigits[d]);
      }
    }
  }

  int _castToExponentialStringReal(Number x, StringBuilder string, bool engFormat, RefInt nDigits) {
    if (x.isNegative()) {
      string.append('-');
    }

    var mantissa = x.abs();
    var base_ = Number.fromInt(numberBase);
    var base3 = base_.xpowyInteger(3);
    var base10 = base_.xpowyInteger(10);
    var t = Number.fromInt(1);
    var base10inv = t.divide(base10);

    var exponent = 0;
    if (!mantissa.isZero()) {
      while (!engFormat && mantissa.compare(base10) >= 0) {
        exponent += 10;
        mantissa = mantissa.multiply(base10inv);
      }

      while ((!engFormat && mantissa.compare(base_) >= 0) ||
              (engFormat && (mantissa.compare(base3) >= 0 || exponent % 3 != 0))) {
        exponent += 3;
        mantissa = mantissa.divide(base_);
      }


    }
  }

  String _castToExponentialString(Number x, bool engFormat) {
    var string = StringBuffer();
    // Handle exponential string conversion
    return string.toString();
  }

  void _appendExponent(StringBuffer string, int exponent) {
    // Handle appending exponent
  }
}
