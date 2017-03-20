import dr.DiceExpression;

typedef State = {
  page: PageView
}

enum PageView {
  DiceSimulator(expr: Expression);
}

enum Expression {
  Unparsed(source: String);
  Parsed(source: String, normalized: String, expr: DiceExpression);
  Error(source: String, message: String);
}
