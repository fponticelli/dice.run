import dr.DiceParser.parse;
using dr.DiceExpressionExtensions;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    return switch action {
      case EvaluateExpression(expr):
        switch parse(expr) {
          case Left(e):
            { expression: Error(expr, e.toString()) };
          case Right(parsed):
            { expression: Parsed(expr, parsed.toString(), parsed) };
        }
    };
  }
}
