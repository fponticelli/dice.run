import dr.DiceExpression;

typedef State = {
  page: PageView
}

enum PageView {
  DiceSimulator(expr: Expression);
}

enum Expression {
  Unparsed(src: String);
  Parsed(src: String, expr: DiceExpression);
  Error(src: String, message: String);
}