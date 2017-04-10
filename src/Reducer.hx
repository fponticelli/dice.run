import dr.DiceParser.parse;
using dr.DiceExpressionExtensions;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    return switch action {
      case EvaluateExpression(expr):
        switch parse(expr) {
          case Left(e):
            { expression: Error(expr, e), seed: state.seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
          case Right(parsed):
            switch DiceExpressionExtensions.validate(parsed) {
              case None:
                { expression: Parsed(expr, parsed.toString(), parsed), seed: state.seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
              case Some(errs):
                { expression: ParsedInvalid(expr, errs, parsed), seed: state.seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
            }
        }
      case UpdateSeed(seed):
        { expression: state.expression, seed: seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
      case ToggleUseSeed(value):
        { expression: state.expression, seed: state.seed, useSeed: value, displayTooltip: state.displayTooltip };
      case HideTooltip:
        { expression: state.expression, seed: state.seed, useSeed: state.useSeed, displayTooltip: false };
      case Composite(a, b):
        reduce(reduce(state, a), b);
    };
  }
}
