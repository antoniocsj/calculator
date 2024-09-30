import 'package:calculator/enums.dart';
import 'package:calculator/mpfr_bindings.dart';
import 'package:calculator/types.dart';
import 'package:calculator/number.dart';

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
  Parser parser; // Reference to parser.
  final PreLexer prelexer; // Pre-lexer is part of lexer.
  final List<LexerToken> tokens = []; // List of LexerTokens.
  int nextToken = 0; // Index of next, to be sent, token.
  final int numberBase;

  Lexer(String input, {this.numberBase = 10}) : prelexer = PreLexer(input);

  void scan() {
    while (true) {
      var tokenType = prelexer.getNextToken();
      insertToken(tokenType);
      if (tokenType == LexerTokenType.plEOS) {
        break;
      }
    }
  }

  // Get next token interface. Will be called by parser to get pointer to next token in token stream.
  LexerToken getNextToken() {
    if (nextToken >= tokens.length) {
      return tokens.last;
    }
    return tokens[nextToken++];
  }

  // Roll back one lexer token.
  void rollBack() {
    if (nextToken > 0) {
      nextToken--;
    }
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
    if (parser.unitIsDefined(name)) {
      return true;
    }

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

    var tmp = Number().mpSetFromString(text, numberBase);
    if (tmp != null) {
      return true;
    }
    else {
      // Try to rollback several characters to see, if that yields any number.
      while (text != '') {
        tmp = Number().mpSetFromString(text, numberBase);
        if (tmp != null) {
          return true;
        }
        count++;
        prelexer.rollBack();
        text = prelexer.getMarkedSubstring();
      }

      // Rollback to original position.
      while (count-- > 0) {
        prelexer.getNextToken();
      }

      return false;
    }

  }

  // Insert generated token to the lexer
  LexerToken insertToken(LexerTokenType type) {
    var token = LexerToken(
      prelexer.getMarkedSubstring(),
      prelexer.markIndex,
      prelexer.index,
      type
    );

    return token;
  }

  // Generates next token from pre-lexer stream and call insert_token () to insert it at the end.
  LexerToken insertNextToken() {
    // Mark start of next token
    prelexer.setMarker();

    // Ignore whitespace
    var type = prelexer.getNextToken();
    while (type == LexerTokenType.plSkip) {
      prelexer.setMarker();
      type = prelexer.getNextToken();
    }

    if (type == LexerTokenType.and || type == LexerTokenType.or || type == LexerTokenType.xor || type == LexerTokenType.not
        || type == LexerTokenType.add || type == LexerTokenType.subtract || type == LexerTokenType.multiply || type == LexerTokenType.divide
        || type == LexerTokenType.lFloor || type == LexerTokenType.rFloor || type == LexerTokenType.lCeiling || type == LexerTokenType.rCeiling
        || type == LexerTokenType.root || type == LexerTokenType.root_3 || type == LexerTokenType.root_4 || type == LexerTokenType.assign
        || type == LexerTokenType.lRBracket || type == LexerTokenType.rRBracket || type == LexerTokenType.lSBracket
        || type == LexerTokenType.rSBracket || type == LexerTokenType.lCBracket || type == LexerTokenType.rCBracket
        || type == LexerTokenType.abs || type == LexerTokenType.power || type == LexerTokenType.factorial || type == LexerTokenType.percentage
        || type == LexerTokenType.argumentSeparator || type == LexerTokenType.shiftLeft || type == LexerTokenType.shiftRight
        || type == LexerTokenType.funcDescSeparator) {
      return insertToken(type);
    }

    // [LexerTokenType.PL_SUPER_MINUS][LexerTokenType.PL_SUPER_DIGIT]+
    if (type == LexerTokenType.plSuperMinus) {
      if ((type = prelexer.getNextToken()) != LexerTokenType.plSuperDigit) {
        // ERROR: expected LexerTokenType.PL_SUP_DIGIT
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

    // [LexerTokenType.PL_FRACTION]+
    if (type == LexerTokenType.plFraction) {
      return insertToken(LexerTokenType.number);
    }

    if (type == LexerTokenType.plDigit) {
      return insertDigit();
    }

    if (type == LexerTokenType.plDecimal) {
      return insertDecimal();
    }

    if (type == LexerTokenType.plHex) {
      return insertHex();
    }

    if (type == LexerTokenType.plLetter) {
      return insertLetter();
    }

    if (type == LexerTokenType.plDegree) {
      type = prelexer.getNextToken();
      if ((type == LexerTokenType.plHex || type == LexerTokenType.plLetter) && checkIfUnit()) {
        return insertToken(LexerTokenType.unit);
      }
    }

    if (type == LexerTokenType.plEOS) {
      return insertToken(LexerTokenType.plEOS);
    }

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
              // ERROR: expected LexerTokenType.PL_SECOND
              parser.setError(ErrorCode.mp, prelexer.getMarkedSubstring(), prelexer.markIndex, prelexer.index);
              return insertToken(LexerTokenType.unknown);
            }
          }
          else if (type == LexerTokenType.plDecimal) {
            return insertAngleNumDMS();
          }
          else {
            prelexer.rollBack();
            return insertToken(LexerTokenType.number);
          }
        }
        else {
          // ERROR: expected LexerTokenType.PL_MINUTE | LexerTokenType.PL_DIGIT
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
      return insertToken(LexerTokenType.number);
    }
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
