import 'package:calculator/enums.dart';

class PreLexer {
  String stream; // String being scanned
  late int index; // Current character index
  late int
      markIndex; // Location, last marked. Useful for getting substrings as part of highlighting
  bool eos = false;

  PreLexer(this.stream) {
    index = 0;
    markIndex = 0;
  }

  // Roll back last scanned character.
  void rollBack() {
    if (eos) {
      eos = false;
      return;
    }
    if (index > 0) {
      index--;
    }
  }

  // Set marker index. To be used for highlighting and error reporting.
  void setMarker() {
    markIndex = index;
  }

  // Get marked substring. To be used for error reporting.
  String getMarkedSubstring() {
    return stream.substring(markIndex, index - markIndex);
  }

  // Pre-Lexer tokenizer. To be called only by Lexer.
  LexerTokenType getNextToken() {
    if (index >= stream.length) {
      // End of stream. Return PL_EOS and stop scanning.
      eos = true;
      return LexerTokenType.plEOS;
    }
    eos = false;

    var c = stream[index++]; // Get next character

    if (c == ',' || c == '.') return LexerTokenType.plDecimal;
    if (isDigit(c)) return LexerTokenType.plDigit;
    if (isHex(c)) return LexerTokenType.plHex;
    if (isSuperDigit(c)) return LexerTokenType.plSuperDigit;
    if (c == '⁻') return LexerTokenType.plSuperMinus;
    if (isSubDigit(c)) return LexerTokenType.plSubDigit;
    if (isFraction(c)) return LexerTokenType.plFraction;
    if (c == '˚' || c == '°') return LexerTokenType.plDegree;
    if (c == "'") return LexerTokenType.plMinute;
    if (c == '"') return LexerTokenType.plSecond;
    if (isAlpha(c) || c == '_' || c == '\\') return LexerTokenType.plLetter;
    if (c == '∧') return LexerTokenType.and;
    if (c == '∨') return LexerTokenType.or;
    if (c == '⊻' || c == '⊕') return LexerTokenType.xor;
    if (c == '¬' || c == '~') return LexerTokenType.not;
    if (c == '+') return LexerTokenType.add;
    if (c == '-' || c == '−' || c == '–') return LexerTokenType.subtract;
    if (c == '*' || c == '×') return LexerTokenType.multiply;
    if (c == '/' || c == '∕' || c == '÷') return LexerTokenType.divide;
    if (c == '⌊') return LexerTokenType.lFloor;
    if (c == '⌋') return LexerTokenType.rFloor;
    if (c == '⌈') return LexerTokenType.lCeiling;
    if (c == '⌉') return LexerTokenType.rCeiling;
    if (c == '√') return LexerTokenType.root;
    if (c == '∛') return LexerTokenType.root_3;
    if (c == '∜') return LexerTokenType.root_4;
    if (c == '=') return LexerTokenType.assign;
    if (c == '(') return LexerTokenType.lRBracket;
    if (c == ')') return LexerTokenType.rRBracket;
    if (c == '[') return LexerTokenType.lSBracket;
    if (c == ']') return LexerTokenType.rSBracket;
    if (c == '{') return LexerTokenType.lCBracket;
    if (c == '}') return LexerTokenType.rCBracket;
    if (c == '|') return LexerTokenType.abs;
    if (c == '^') return LexerTokenType.power;
    if (c == '!') return LexerTokenType.factorial;
    if (c == '%') return LexerTokenType.percentage;
    if (c == ';') return LexerTokenType.argumentSeparator;
    if (c == '»') return LexerTokenType.shiftRight;
    if (c == '«') return LexerTokenType.shiftLeft;
    if (c == ' ' || c == '\r' || c == '\t' || c == '\n') return LexerTokenType.plSkip;
    if (c == '@') return LexerTokenType.funcDescSeparator;

    return LexerTokenType.unknown;
  }

  bool isDigit(String c) =>
      c.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
      c.codeUnitAt(0) <= '9'.codeUnitAt(0);

  bool isHex(String c) =>
      (c.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
          c.codeUnitAt(0) <= 'f'.codeUnitAt(0)) ||
      (c.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          c.codeUnitAt(0) <= 'F'.codeUnitAt(0));

  bool isSuperDigit(String c) => '⁰¹²³⁴⁵⁶⁷⁸⁹'.contains(c);

  bool isSubDigit(String c) => '₀₁₂₃₄₅₆₇₈₉'.contains(c);

  bool isFraction(String c) => '½⅓⅔¼¾⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞'.contains(c);

  bool isAlpha(String c) =>
      (c.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
          c.codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
      (c.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          c.codeUnitAt(0) <= 'Z'.codeUnitAt(0));
}

class LexerToken {
  String text;                // Copy of token string
  int startIndex;             // Start index in original stream
  int endIndex;               // End index in original stream
  LexerTokenType type;        // Type of token

  LexerToken({
    required this.text,
    required this.startIndex,
    required this.endIndex,
    required this.type,
  });
}

class Lexer {
  Parser parser; // Pointer to the parser parser
  late PreLexer prelexer; // Pre-lexer. Pre-lexer is part of lexer
  late List<LexerToken> tokens; // Pointer to the dynamic array of LexerTokens
  late int nextToken; // Index of next, to be sent, token
  late int numberBase;

  Lexer(String input, this.parser, {this.numberBase = 10}) {
    prelexer = PreLexer(input);
    tokens = [];
    nextToken = 0;
  }

  void scan() {
    while (true) {
      var token = insertNextToken();
      tokens.add(token);
      if (token.type == LexerTokenType.plEOS) break;
    }
  }

  // Get next token interface.
  // It Will be called by parser to get pointer to next token in token stream.
  LexerToken getNextToken() {
    if (nextToken >= tokens.length) {
      return tokens.last;
    }
    return tokens[nextToken++];
  }

  // Roll back one lexer token.
  void rollBack() {
    if (nextToken > 0) nextToken--;
  }

  bool checkIfFunction() {
    var name = prelexer.getMarkedSubstring();
    return parser.functionIsDefined(name);
  }

  bool checkIfUnit() {
    int superCount = 0;
    while (prelexer.getNextToken() == LexerTokenType.plSuperDigit) {
      superCount++;
    }

    prelexer.rollBack();

    var name = prelexer.getMarkedSubstring();
    if (parser.unitIsDefined(name)) return true;

    while (superCount-- > 0) {
      prelexer.rollBack();
    }

    name = prelexer.getMarkedSubstring();
    return parser.unitIsDefined(name);
  }

  bool checkIfLiteralBase() {
    var name = prelexer.getMarkedSubstring();
    return parser.literalBaseIsDefined(name.toLowerCase());
  }

  bool checkIfNumber() {
    int count = 0;
    var text = prelexer.getMarkedSubstring();

    var tmp = mpSetFromString(text, numberBase);
    if (tmp != null) {
      return true;
    }
    else {
      // Try to rollback several characters to see, if that yields any number.
      while (text.isNotEmpty) {
        tmp = mpSetFromString(text, numberBase);
        if (tmp != null) {
          return true;
        }
        count++;
        prelexer.rollBack();
        text = prelexer.getMarkedSubstring();
      }

      // Undo all rollbacks.
      while (count-- > 0) {
        prelexer.getNextToken();
      }

      return false;
    }
  }

  // Insert generated token to the lexer
  LexerToken insertToken(LexerTokenType type) {
    return LexerToken(
      text: prelexer.getMarkedSubstring(),
      startIndex: prelexer.markIndex,
      endIndex: prelexer.index,
      type: type,
    );
  }

  // Generates next token from pre-lexer stream and call insertToken() to insert it at the end.
  LexerToken insertNextToken() {
    // Mark start of next token
    prelexer.setMarker();

    // Ignore whitespace
    var type = prelexer.getNextToken();

    while (type == LexerTokenType.plSkip) {
      prelexer.setMarker();
      type = prelexer.getNextToken();
    }

    if ([
      LexerTokenType.and,
      LexerTokenType.or,
      LexerTokenType.xor,
      LexerTokenType.not,
      LexerTokenType.add,
      LexerTokenType.subtract,
      LexerTokenType.multiply,
      LexerTokenType.divide,
      LexerTokenType.lFloor,
      LexerTokenType.rFloor,
      LexerTokenType.lCeiling,
      LexerTokenType.rCeiling,
      LexerTokenType.root,
      LexerTokenType.root_3,
      LexerTokenType.root_4,
      LexerTokenType.assign,
      LexerTokenType.lRBracket,
      LexerTokenType.rRBracket,
      LexerTokenType.lSBracket,
      LexerTokenType.rSBracket,
      LexerTokenType.lCBracket,
      LexerTokenType.rCBracket,
      LexerTokenType.abs,
      LexerTokenType.power,
      LexerTokenType.factorial,
      LexerTokenType.percentage,
      LexerTokenType.argumentSeparator,
      LexerTokenType.shiftLeft,
      LexerTokenType.shiftRight,
      LexerTokenType.funcDescSeparator
    ].contains(type)) {
      return insertToken(type);
    }

    // [LexerTokenType.PL_SUPER_MINUS][LexerTokenType.PL_SUPER_DIGIT]+
    if (type == LexerTokenType.plSuperMinus) {
      if ((type = prelexer.getNextToken()) != LexerTokenType.plSuperDigit) {
        // ERROR: expected super digit
        parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
        return insertToken(LexerTokenType.unknown);
      }

      // Get all LexerTokenType.PL_SUPER_DIGITs.
      while (prelexer.getNextToken() == LexerTokenType.plSuperDigit) {}
      prelexer.rollBack();

      return insertToken(LexerTokenType.nSupNumber);
    }

    // [LexerTokenType.PL_SUPER_DIGIT]+
    if (type == LexerTokenType.plSuperDigit) {
      while (prelexer.getNextToken() == LexerTokenType.plSuperDigit) {}
      prelexer.rollBack();

      return insertToken(LexerTokenType.supNumber);
    }

    // [LexerTokenType.PL_SUB_DIGIT]+
    if (type == LexerTokenType.plSubDigit) {
      while (prelexer.getNextToken() == LexerTokenType.plSubDigit) {}
      prelexer.rollBack();

      return insertToken(LexerTokenType.subNumber);
    }

    // [LexerTokenType.PL_FRACTION]
    if (type == LexerTokenType.plFraction) return insertToken(LexerTokenType.number);

    if (type == LexerTokenType.plDigit) return insertDigit();

    if (type == LexerTokenType.plDecimal) return insertDecimal();

    if (type == LexerTokenType.plHex) return insertHex();

    if (type == LexerTokenType.plLetter) return insertLetter();

    if (type == LexerTokenType.plDegree) {
      type = prelexer.getNextToken();
      if ((type == LexerTokenType.plHex || type == LexerTokenType.plLetter) && checkIfUnit()) {
        return insertToken(LexerTokenType.unit);
      }
    }

    if (type == LexerTokenType.plEOS) return insertToken(LexerTokenType.plEOS);

    // ERROR: Unexpected token
    parser.setError(ErrorCode.invalid, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);

    return insertToken(LexerTokenType.unknown);
  }

  LexerToken insertDigit() {
    var type = prelexer.getNextToken();
    while (type == LexerTokenType.plDigit) {
      type = prelexer.getNextToken();
    }

    if (type == LexerTokenType.plFraction) {
      return insertToken(LexerTokenType.number);
    }
    else if (type == LexerTokenType.plSubDigit) {
      while (prelexer.getNextToken() == LexerTokenType.plSubDigit) {}
      prelexer.rollBack();
      return insertToken(LexerTokenType.number);
    }
    else if (type == LexerTokenType.plDegree) {
      type = prelexer.getNextToken();
      if (type == LexerTokenType.plDigit) {
        while ((type = prelexer.getNextToken()) == LexerTokenType.plDigit) {}
        if (type == LexerTokenType.plDecimal) {
          return insertAngleNumDM();
        }
        else if (type == LexerTokenType.plMinute) {
          type = prelexer.getNextToken();
          if (type == LexerTokenType.plDigit) {
            while ((type = prelexer.getNextToken()) == LexerTokenType.plDigit) {}
            if (type == LexerTokenType.plDecimal) {
              return insertAngleNumDMS();
            }
            else if (type == LexerTokenType.plSecond) {
              return insertToken(LexerTokenType.number);
            }
            else {
              // ERROR: expected LexerTokenType.plSecond
              parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
              return insertToken(LexerTokenType.unknown);
            }
          }
          else if (type == LexerTokenType.plDecimal) {
            return insertAngleNumDM();
          }
          else {
            prelexer.rollBack();
            return insertToken(LexerTokenType.number);
          }
        }
        else {
          // ERROR: expected LexerTokenType.plMinute | LexerTokenType.plDigit
          parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
          return insertToken(LexerTokenType.unknown);
        }
      }
      else if (type == LexerTokenType.plDecimal) {
        return insertAngleNumDM();
      }
      else {
        return insertToken(LexerTokenType.number);
      }
    }
    else if (type == LexerTokenType.plDecimal) {
      return insertDecimal();
    }
    else if (checkIfLiteralBase()) {
      return insertHex();
    }
    else if (type == LexerTokenType.plHex) {
      return insertHexDec();
    }
    else {
      prelexer.rollBack();
      return insertToken(LexerTokenType.number);
    }
  }

  LexerToken insertAngleNumDM() {
    var type = prelexer.getNextToken();
    if (type != LexerTokenType.plDigit) {
      // ERROR: expected LexerTokenType.plDigit
      parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
      return insertToken(LexerTokenType.unknown);
    }

    while (type == LexerTokenType.plDigit) {
      type = prelexer.getNextToken();
    }

    if (type == LexerTokenType.plMinute) {
      return insertToken(LexerTokenType.number);
    }
    else {
      // ERROR: expected LexerTokenType.plMinute
      parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
      return insertToken(LexerTokenType.unknown);
    }
  }

  LexerToken insertAngleNumDMS() {
    var type = prelexer.getNextToken();
    if (type != LexerTokenType.plDigit) {
      // ERROR: expected LexerTokenType.plDigit
      parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
      return insertToken(LexerTokenType.unknown);
    }
    while ((type = prelexer.getNextToken()) == LexerTokenType.plDigit) {}
    if (type == LexerTokenType.plSecond) {
      return insertToken(LexerTokenType.number);
    } else {
      // ERROR: expected LexerTokenType.plSecond
      parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
      return insertToken(LexerTokenType.unknown);
    }
  }

  LexerToken insertDecimal() {
    var type = prelexer.getNextToken();
    if (type == LexerTokenType.plDigit) {
      while (prelexer.getNextToken() == LexerTokenType.plDigit) {}
      if (type == LexerTokenType.plDegree) {
        return insertToken(LexerTokenType.number);
      }
      else if (type == LexerTokenType.plHex) {
        return insertDecimalHex();
      }
      else if (type == LexerTokenType.plSubDigit) {
        while (prelexer.getNextToken() == LexerTokenType.plSubDigit) {}
        prelexer.rollBack();
        return insertToken(LexerTokenType.number);
      }
      else {
        prelexer.rollBack();
        return insertToken(LexerTokenType.number);
      }
    }
    else if (type == LexerTokenType.plHex) {
      return insertDecimalHex();
    }
    else {
      // ERROR: expected LexerTokenType.plDigit | LexerTokenType.plHex
      parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
      return insertToken(LexerTokenType.unknown);
    }
  }

  LexerToken insertHex() {
    var type = prelexer.getNextToken();
    while (type == LexerTokenType.plHex) {
      type = prelexer.getNextToken();
    }

    if (type == LexerTokenType.plDigit) {
      return insertHexDec();
    }
    else if (type == LexerTokenType.plDecimal) {
      return insertDecimalHex();
    }
    else if (type == LexerTokenType.plSubDigit) {
      while (prelexer.getNextToken() == LexerTokenType.plSubDigit) {}
      prelexer.rollBack();

      if (checkIfNumber()) {
        return insertToken(LexerTokenType.number);
      }
      else {
        if (checkIfFunction()) {
          return insertToken(LexerTokenType.function);
        }
        else if (checkIfUnit()) {
          return insertToken(LexerTokenType.unit);
        }
        else {
          return insertToken(LexerTokenType.variable);
        }
      }
    }
    else if (type == LexerTokenType.plLetter) {
      return insertLetter();
    }
    else {
      prelexer.rollBack();
      if (checkIfNumber()) {
        return insertToken(LexerTokenType.number);
      }
      else {
        if (checkIfFunction()) {
          return insertToken(LexerTokenType.function);
        }
        else if (checkIfUnit()) {
          return insertToken(LexerTokenType.unit);
        }
        else {
          return insertToken(LexerTokenType.variable);
        }
      }
    }
  }

  LexerToken insertHexDec() {
    var type = prelexer.getNextToken();
    while (type == LexerTokenType.plDigit || type == LexerTokenType.plHex) {
      type = prelexer.getNextToken();
    }

    if (type == LexerTokenType.plDecimal) {
      return insertDecimalHex();
    }
    else if (type == LexerTokenType.plSubDigit) {
      while (prelexer.getNextToken() == LexerTokenType.plSubDigit) {}
      prelexer.rollBack();
      return insertToken(LexerTokenType.number);
    }
    else {
      if (checkIfNumber()) {
        return insertToken(LexerTokenType.number);
      }
      // ERROR: expected LexerTokenType.plDecimal | LexerTokenType.plDigit | LexerTokenType.plHex
      parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
      return insertToken(LexerTokenType.unknown);
    }
  }

  LexerToken insertDecimalHex() {
    // Make up of digits and hexadecimal characters
    var type = prelexer.getNextToken();
    while (type == LexerTokenType.plDigit || type == LexerTokenType.plHex) {
      type = prelexer.getNextToken();
    }

    // Allow a subdigit suffix
    while (type == LexerTokenType.plSubDigit) {
      type = prelexer.getNextToken();
    }

    prelexer.rollBack();

    return insertToken(LexerTokenType.number);
  }

  LexerToken insertLetter() {
    // Get string of letters
    var type = prelexer.getNextToken();
    while (type == LexerTokenType.plLetter || type == LexerTokenType.plHex) {
      type = prelexer.getNextToken();
    }

    // Allow a subdigit suffix
    while (type == LexerTokenType.plSubDigit) {
      type = prelexer.getNextToken();
    }

    prelexer.rollBack();

    var name = prelexer.getMarkedSubstring().toLowerCase();

    if (name == "mod") return insertToken(LexerTokenType.mod);
    if (name == "and") return insertToken(LexerTokenType.and);
    if (name == "\\cdot") return insertToken(LexerTokenType.multiply);
    if (name == "or") return insertToken(LexerTokenType.or);
    if (name == "xor") return insertToken(LexerTokenType.xor);
    if (name == "not") return insertToken(LexerTokenType.not);
    // Translators: conversion keyword, used e.g. 1 EUR in USD, 1 EUR to USD
    if (name == "in" || name == "to") return insertToken(LexerTokenType.in_);
    if (checkIfFunction()) {
      return insertToken(LexerTokenType.function);
    }
    if (checkIfUnit()) {
      return insertToken(LexerTokenType.unit);
    } else {
      return insertToken(LexerTokenType.variable);
    }
  }
}
