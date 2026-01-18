abstract class ASTNode {}

class IfStatement extends ASTNode {
  final Expression condition;
  final Action action;
  IfStatement(this.condition, this.action);
}

abstract class Expression extends ASTNode {}

class BinaryExpression extends Expression {
  final Expression left;
  final String op;
  final Expression right;
  BinaryExpression(this.left, this.op, this.right);
}

class FunctionCall extends Expression {
  final String name;
  final List<Expression> args;
  FunctionCall(this.name, this.args);
}

class NumberLiteral extends Expression {
  final double value;
  NumberLiteral(this.value);
}

class Identifier extends Expression {
  final String name;
  Identifier(this.name);
}

class Action extends ASTNode {
  final String type;
  Action(this.type);
}
