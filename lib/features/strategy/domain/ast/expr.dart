abstract class Expr {
  bool eval(Map<String, double> ctx);
}

class GreaterThan extends Expr {
  final String left;
  final String right;

  GreaterThan(this.left, this.right);

  @override
  bool eval(Map<String, double> ctx) {
    return ctx[left]! > ctx[right]!;
  }
}

class LessThan extends Expr {
  final String left;
  final String right;

  LessThan(this.left, this.right);

  @override
  bool eval(Map<String, double> ctx) {
    return ctx[left]! < ctx[right]!;
  }
}

class AndExpr extends Expr {
  final Expr a, b;
  AndExpr(this.a, this.b);

  @override
  bool eval(Map<String, double> ctx) => a.eval(ctx) && b.eval(ctx);
}
