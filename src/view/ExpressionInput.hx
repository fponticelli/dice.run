package view;

import doom.html.Component;
import doom.html.Html.*;
import State;
import dots.Query;

class ExpressionInput extends Component<SimulatorProps> {
  var start = 0;
  var end = 0;
  override function render() {
    var value = switch props.expr {
      case Unparsed(src): src;
      case Parsed(src, _): src;
      case Error(src, _): src;
    }
    var top = [div([
        "class" => "expression-input"
      ],
      span([
        "class" => "text-editor",
        // "value" => value,
        "contentEditable" => "true",
        "input" => onInput,
        "keyup" => selectionChange
      ], value))];
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

  override function didUpdate() {
    var input: js.html.InputElement = cast this.element; // cast Query.find("input", this.element);
    // input.setSelectionRange(start, end);
  }

  function selectionChange(input: js.html.InputElement) {
    start = input.selectionStart;
    end = input.selectionEnd;
  }

  function onInput(input: js.html.InputElement) {
    selectionChange(input);
    props.dispatch(EvaluateExpression(input.textContent));
  }
}

typedef SimulatorProps = {
  dispatch: Api,
  expr: Expression
}
