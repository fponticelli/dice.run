package view;

import doom.html.Component;
import doom.html.Html.*;
import State;
import dr.DiceParser.DiceParseError;
using thx.Arrays;
using thx.Functions;

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
          case Error(_, err):
            [div(["class" => "error"], renderError(err))];
          case _:
            [];
        };
    return div(
      top.concat(bottom)
    );
  }

  static function renderError(err: DiceParseError) {
    return [span(["class" => "label"], "expected one of"), br()]
    .concat(
      err.expected
        .map.fn(span(["class" => "expected"], _))
        .interspersef(function() return span(", "))
    )
    .concat([
      br(),
      span(["class" => "label"], "found")
    ])
    .concat(
      switch err.positionToString() {
        case None: [span(["class" => "eof"], " end of file")];
        case Some(content): [br(), span(["class" => "got"], content)];
      }
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
