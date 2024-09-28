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
    switch (c) {
      case ',':
      case '.':
        return LexerTokenType.plDecimal;
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        return LexerTokenType.plDigit;
      case 'A':
      case 'B':
      case 'C':
      case 'D':
      case 'E':
      case 'F':
        return LexerTokenType.plHex;
      case '-':
        return LexerTokenType.plSuperMinus;
      case ' ':
      case '\n':
      case '\t':
        return LexerTokenType.plSkip;
      default:
        return LexerTokenType.plLetter;
    }
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
