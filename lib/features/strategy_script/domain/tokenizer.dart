import 'token.dart';

class Tokenizer {
  final String _input;
  int _pos = 0;

  Tokenizer(this._input);

  List<Token> tokenize() {
    final tokens = <Token>[];

    while (_pos < _input.length) {
      final c = _input[_pos];

      if (c.trim().isEmpty) { _pos++; continue; }

      if (isLetter(c)) {
        final word = readWhile(isLetter);
        if (word.toUpperCase() == 'IF') tokens.add(Token(TokenType.keywordIf, word));
        else if (word.toUpperCase() == 'THEN') tokens.add(Token(TokenType.keywordThen, word));
        else tokens.add(Token(TokenType.identifier, word));
        continue;
      }

      if (isDigit(c)) {
        final numStr = readWhile((ch) => isDigit(ch) || ch == '.');
        tokens.add(Token(TokenType.number, numStr));
        continue;
      }

      switch (c) {
        case '>':
        case '<':
        case '=':
          tokens.add(Token(TokenType.comparison, c));
          break;
        case ',':
          tokens.add(Token(TokenType.comma, c));
          break;
        case '(':
          tokens.add(Token(TokenType.leftParen, c));
          break;
        case ')':
          tokens.add(Token(TokenType.rightParen, c));
          break;
        case ';':
          tokens.add(Token(TokenType.semicolon, c));
          break;
      }

      _pos++;
    }

    tokens.add(Token(TokenType.eof, ''));
    return tokens;
  }

  bool isLetter(String c) => RegExp(r'[A-Za-z_]').hasMatch(c);
  bool isDigit(String c) => RegExp(r'[0-9]').hasMatch(c);

  String readWhile(bool Function(String) test) {
    final start = _pos;
    while (_pos < _input.length && test(_input[_pos])) _pos++;
    return _input.substring(start, _pos);
  }
}
