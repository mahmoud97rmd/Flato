import 'token.dart';
import 'tokenizer.dart';
import 'ast.dart';

class Parser {
  final List<Token> tokens;
  int _pos = 0;

  Parser(this.tokens);

  Token get current => tokens[_pos];

  void advance() => _pos++;

  bool accept(TokenType type) {
    if (current.type == type) { advance(); return true; }
    return false;
  }

  ASTNode? parse() {
    if (accept(TokenType.keywordIf)) {
      final cond = parseExpression();
      expect(TokenType.keywordThen);
      final act = parseAction();
      expect(TokenType.semicolon);
      return IfStatement(cond!, act);
    }
    return null;
  }

  Expression? parseExpression() {
    if (current.type == TokenType.identifier) {
      final name = current.lexeme;
      advance();
      if (accept(TokenType.leftParen)) {
        final args = <Expression>[];
        while (!accept(TokenType.rightParen)) {
          final expr = parseExpression();
          if (expr != null) args.add(expr);
          accept(TokenType.comma);
        }
        return FunctionCall(name, args);
      }
      return Identifier(name);
    }
    if (current.type == TokenType.number) {
      final val = double.parse(current.lexeme);
      advance();
      return NumberLiteral(val);
    }
    return null;
  }

  Action parseAction() {
    final name = current.lexeme;
    advance();
    return Action(name);
  }

  void expect(TokenType type) {
    if (current.type != type) throw Exception("Expected $type");
    advance();
  }
}
