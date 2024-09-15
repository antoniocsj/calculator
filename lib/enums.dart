
enum AngleUnit {
  radians,
  degrees,
  gradians
}

enum ErrorCode {
  none,
  invalid,
  overflow,
  unknownVariable,
  unknownFunction,
  unknownConversion,
  mp
}

enum LexerTokenType {
  unknown, // Unknown

  // These are all Pre-Lexer tokens, returned by pre-lexer
  plDecimal, // Decimal separator
  plDigit, // Decimal digit
  plHex, // A-F of Hex digits
  plSuperDigit, // Super digits
  plSuperMinus, // Super minus
  plSubDigit, // Sub digits
  plFraction, // Fractions
  plDegree, // Degree
  plMinute, // Minutes
  plSecond, // Seconds
  plLetter, // Alphabets
  plEOS, // End of stream
  plSkip, // Skip this symbol (whitespace or newline)

  // These are all tokens, returned by Lexer
  add, // Plus
  subtract, // Minus
  multiply, // Multiply
  divide, // Divide
  mod, // Modulus
  lFloor, // Floor (Left)
  rFloor, // Floor (Right)
  lCeiling, // Ceiling (Left)
  rCeiling, // Ceiling (Right)
  root, // Square root
  root_3, // Cube root
  root_4, // Fourth root
  not, // Bitwise NOT
  and, // Bitwise AND
  or, // Bitwise OR
  xor, // Bitwise XOR
  in_, // IN (for converter e.g. 1 EUR in USD / 1 EUR to USD)
  number, // Number
  supNumber, // Super Number
  nSupNumber, // Negative Super Number
  subNumber, // Sub Number
  function, // Function
  unit, // Unit of conversion
  variable, // Variable name
  shiftLeft, // Shift left
  shiftRight, // Shift right
  assign, // =
  lRBracket, // (
  rRBracket, // )
  lSBracket, // [
  rSBracket, // ]
  lCBracket, // {
  rCBracket, // }
  abs, // |
  power, // ^
  factorial, // !
  percentage, // %
  argumentSeparator, // ; (Function argument separator)
  funcDescSeparator // @ (Function description separator)
}
