package view;

import doom.html.Component;
import doom.html.Html.*;
import State;

class ExpressionInput extends Component<SimulatorProps> {
  override function render() {
    var value = switch props.expr {
      case Unparsed(src): src;
      case Parsed(src, _): src;
      case Error(src, _): src;
    }
    var top = [div(input([
          "value" => value,
          "input" => onInput
        ]))];
    var bottom = switch props.expr {
          case Error(_, msg):
            [div(msg)];
          case _:
            [];
        };
    return div(
      top.concat(bottom)
    );
  }

  function onInput(value) {
    props.dispatch(EvaluateExpression(value));
  }
}

typedef SimulatorProps = {
  dispatch: Api,
  expr: Expression
}