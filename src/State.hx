import dr.DiceExpression;
import dr.DiceParser.DiceParseError;
import dr.DiceExpressionExtensions;
import thx.Nel;

typedef State = {
  expression: Expression,
  seed: Int,
  useSeed: Bool,
  displayExpressionTooltip: Bool,
  displayRollTooltip: Bool
}

enum Expression {
  Unparsed(source: String);
  Parsed(source: String, normalized: String, expr: DiceExpression);
  ParsedInvalid(source: String, errors: Nel<ValidationMessage>, expr: DiceExpression);
  Error(source: String, err: DiceParseError);
}
