import dr.DiceExpression;
import dr.DiceParser.DiceParseError;

typedef State = {
  expression: Expression,
  seed: Int
}

enum Expression {
  Unparsed(source: String);
  Parsed(source: String, normalized: String, expr: DiceExpression);
  Error(source: String, err: DiceParseError);
}
