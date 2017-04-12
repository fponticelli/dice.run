import dr.DiceParser.parse;
using dr.DiceExpressionExtensions;
using thx.Objects;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    return switch action {
      case EvaluateExpression(expr):
        switch parse(expr) {
          case Left(e):
            state.with(expression, Error(expr, e));
            // displayExpressionTooltip
            // { expression: , seed: state.seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
          case Right(parsed):
            switch DiceExpressionExtensions.validate(parsed) {
              case None:
                state.with(expression, Parsed(expr, parsed.toString(), parsed));
                // { expression: Parsed(expr, parsed.toString(), parsed), seed: state.seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
              case Some(errs):
                state.with(expression, ParsedInvalid(expr, errs, parsed));
                // { expression: ParsedInvalid(expr, errs, parsed), seed: state.seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
            }
        }
      case UpdateSeed(seed):
        state.with(seed, seed);
        // { expression: state.expression, seed: seed, useSeed: state.useSeed, displayTooltip: state.displayTooltip };
      case ToggleUseSeed(value):
        state.with(useSeed, value);
        // { expression: state.expression, seed: state.seed, useSeed: value, displayTooltip: state.displayTooltip };
      case HideExpressionTooltip:
        state.with(displayExpressionTooltip, false);
      case HideRollTooltip:
        state.with(displayRollTooltip, false);
        // { expression: state.expression, seed: state.seed, useSeed: state.useSeed, displayTooltip: false };
      case Composite(a, b):
        reduce(reduce(state, a), b);
    };
  }
}
