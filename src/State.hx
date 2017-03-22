import dr.DiceExpression;

typedef State = {
  expression: Expression,
  seed: Int
}

enum Expression {
  Unparsed(source: String);
  Parsed(source: String, normalized: String, expr: DiceExpression);
  Error(source: String, message: String);
}
