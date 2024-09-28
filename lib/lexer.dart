import 'package:calculator/enums.dart';
import 'package:calculator/types.dart';

// FIXME: Merge into lexer
class PreLexer {
  late String stream; // String being scanned
  late int index; // Current character index
  late int markIndex; // Location, last marked. Useful for getting substrings as part of highlighting
  bool eos = false;

  PreLexer(this.stream) {
    index = 0;
    markIndex = 0;
  }

  // Roll back last scanned character.
  void rollBack() {
    if (eos) {
      eos = false;
    } else if (index > 0) {
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
      // We have to flag if we ran out of chars, as roll_back from PL_EOS should have no effect
      eos = true;
      return LexerTokenType.plEOS;
    }

    eos = false;

    var c = stream[index++];

    if (c == ',' || c == '.') {
      return LexerTokenType.plDecimal;
    }
    // checks if (c >= '0' && c <= '9')
    if (c.isDigit()) {
      return LexerTokenType.plDigit;
    }
    // checks if ((c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))
    if (c.isHexDigit()) {
      return LexerTokenType.plHex;
    }
    if (c == '⁰' || c == '¹' || c == '²' || c == '³' || c == '⁴' || c == '⁵' || c == '⁶' || c == '⁷' || c == '⁸' || c == '⁹') {
      return LexerTokenType.plSubDigit;
    }
    if (c == '⁻') {
      return LexerTokenType.plSuperMinus;
    }
    if (c == '₀' || c == '₁' || c == '₂' || c == '₃' || c == '₄' || c == '₅' || c == '₆' || c == '₇' || c == '₈' || c == '₉') {
      return LexerTokenType.plSubDigit;
    }
    if (c == '½' || c == '⅓' || c == '⅔' || c == '¼' || c == '¾' || c == '⅕' || c == '⅖' || c == '⅗' || c == '⅘' || c == '⅙' || c == '⅚' || c == '⅛' || c == '⅜' || c == '⅝' || c == '⅞') {
      return LexerTokenType.plFraction;
    }
    if (c == '˚' || c == '°') {
      return LexerTokenType.plDegree;
    }
    if (c == '\'') {
      return LexerTokenType.plMinute;
    }
    if (c == '"') {
      return LexerTokenType.plSecond;
    }
    if (c.isAlpha() || c == '_' || c == '\\') {
      return LexerTokenType.plLetter;
    }
    if (c == '∧') {
      return LexerTokenType.and;
    }
    if (c == '∨') {
      return LexerTokenType.or;
    }
    if (c == '⊻' || c == '⊕') {
      return LexerTokenType.xor;
    }
    if (c == '¬' || c == '~') {
      return LexerTokenType.not;
    }
    if (c == '+') {
      return LexerTokenType.add;
    }
    if (c == '-' || c == '−' || c == '–') {
      return LexerTokenType.subtract;
    }
    if (c == '*' || c == '×') {
      return LexerTokenType.multiply;
    }
    if (c == '/' || c == '∕' || c == '÷') {
      return LexerTokenType.divide;
    }
    if (c == '⌊') {
      return LexerTokenType.lFloor;
    }
    if (c == '⌋') {
      return LexerTokenType.rFloor;
    }
    if (c == '⌈') {
      return LexerTokenType.lCeiling;
    }
    if (c == '⌉') {
      return LexerTokenType.rCeiling;
    }
    if (c == '√') {
      return LexerTokenType.root;
    }
    if (c == '∛') {
      return LexerTokenType.root_3;
    }
    if (c == '∜') {
      return LexerTokenType.root_4;
    }
    if (c == '=') {
      return LexerTokenType.assign;
    }
    if (c == '(') {
      return LexerTokenType.lRBracket;
    }
    if (c == ')') {
      return LexerTokenType.rRBracket;
    }
    if (c == '[') {
      return LexerTokenType.lSBracket;
    }
    if (c == ']') {
      return LexerTokenType.rSBracket;
    }
    if (c == '{') {
      return LexerTokenType.lCBracket;
    }
    if (c == '}') {
      return LexerTokenType.rCBracket;
    }
    if (c == '|') {
      return LexerTokenType.abs;
    }
    if (c == '^') {
      return LexerTokenType.power;
    }
    if (c == '!') {
      return LexerTokenType.factorial;
    }
    if (c == '%') {
      return LexerTokenType.percentage;
    }
    if (c == ';') {
      return LexerTokenType.argumentSeparator;
    }
    if (c == '»') {
      return LexerTokenType.shiftRight;
    }
    if (c == '«') {
      return LexerTokenType.shiftLeft;
    }
    if (c == ' ' || c == '\r' || c == '\t' || c == '\n') {
      return LexerTokenType.plSkip;
    }
    if (c == '@') {
      return LexerTokenType.funcDescSeparator;
    }

    return LexerTokenType.unknown;
  }
}

class LexerToken {
  String text; // Copy of token string.
  int startIndex; // Start index in original stream.
  int endIndex; // End index in original stream.
  LexerTokenType type; // Type of token.

  LexerToken(this.text, this.startIndex, this.endIndex, this.type);
}

class Lexer {
  final PreLexer prelexer; // Pre-lexer is part of lexer.
  final List<LexerToken> tokens = []; // List of LexerTokens.
  int nextToken = 0; // Index of next, to be sent, token.
  final int numberBase;

  Lexer(String input, {this.numberBase = 10}) : prelexer = PreLexer(input);

  void scan() {
    while (true) {
      var tokenType = prelexer.getNextToken();
      if (tokenType == LexerTokenType.plEOS) break;
      insertToken(tokenType);
    }
  }

  LexerToken getNextToken() {
    if (nextToken < tokens.length) {
      return tokens[nextToken++];
    }
    return LexerToken('', 0, 0, LexerTokenType.unknown);
  }

  void rollBack() {
    if (nextToken > 0) {
      nextToken--;
    }
  }

  bool checkIfFunction() {
    // Implement function check logic
    return false;
  }

  bool checkIfUnit() {
    // Implement unit check logic
    return false;
  }

  bool checkIfLiteralBase() {
    // Implement literal base check logic
    return false;
  }

  bool checkIfNumber() {
    // Implement number check logic
    return false;
  }

  LexerToken insertToken(LexerTokenType type) {
    var token = LexerToken(prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index, type);
    tokens.add(token);
    return token;
  }

  LexerToken insertNextToken() {
    var tokenType = prelexer.getNextToken();
    return insertToken(tokenType);
  }

  LexerToken insertDigit() {
    // Implement digit insertion logic
    return insertToken(LexerTokenType.plDigit);
  }

  LexerToken insertAngleNumDM() {
    // Implement angle number DM insertion logic
    return insertToken(LexerTokenType.plDegree);
  }

  LexerToken insertAngleNumDMS() {
    // Implement angle number DMS insertion logic
    return insertToken(LexerTokenType.plMinute);
  }

  LexerToken insertDecimal() {
    // Implement decimal insertion logic
    return insertToken(LexerTokenType.plDecimal);
  }

  LexerToken insertHex() {
    // Implement hex insertion logic
    return insertToken(LexerTokenType.plHex);
  }

  LexerToken insertHexDec() {
    // Implement hex decimal insertion logic
    return insertToken(LexerTokenType.plHex);
  }

  LexerToken insertDecimalHex() {
    // Implement decimal hex insertion logic
    return insertToken(LexerTokenType.plDecimal);
  }

  LexerToken insertLetter() {
    // Implement letter insertion logic
    return insertToken(LexerTokenType.plLetter);
  }
}
