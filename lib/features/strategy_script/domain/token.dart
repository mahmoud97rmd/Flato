enum TokenType {
  identifier,
  number,
  comparison,
  comma,
  leftParen,
  rightParen,
  keywordIf,
  keywordThen,
  semicolon,
  eof,
}

class Token {
  final TokenType type;
  final String lexeme;
  Token(this.type, this.lexeme);
}
