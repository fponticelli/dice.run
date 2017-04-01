import dr.DiceParser.parse;
using dr.DiceExpressionExtensions;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    return switch action {
      case EvaluateExpression(expr):
        switch parse(expr) {
          case Left(e):
            { expression: Error(expr, e), seed: state.seed, useSeed: state.useSeed };
          case Right(parsed):
            switch DiceExpressionExtensions.validate(parsed) {
              case None:
                { expression: Parsed(expr, parsed.toString(), parsed), seed: state.seed, useSeed: state.useSeed };
              case Some(errs):
                { expression: ParsedInvalid(expr, errs, parsed), seed: state.seed, useSeed: state.useSeed };
            }
        }
      case UpdateSeed(seed):
        { expression: state.expression, seed: seed, useSeed: state.useSeed };
      case ToggleUseSeed(value):
        { expression: state.expression, seed: state.seed, useSeed: value };
    };
  }
}
