package view;

import doom.html.Component;
import doom.html.Html.*;
import doom.core.VNode;
import dr.DiceExpression;
import dr.RollResult;
using thx.Arrays;

class RollDetailsView extends Component<RollResult> {
  override function render() {
    return renderRollResult(props);
  }

  function renderRollResult(result: RollResult) {
    return switch result {
      case OneResult(die):
        renderDie(die);
      case LiteralResult(value, result):
        div(["class" => "literal"], '$result');
      case BinaryOpResult(op, a, b, result):
        div(["class" => "binop"], [
          div(["class" => "left"], new RollDetailsView(a).asNode()),
          div(["class" => "op"], renderOp(op)),
          div(["class" => "right"], new RollDetailsView(b).asNode())
        ]);
      case DiceReduceResult(DiceExpressionsResult(rolls), reducer, result):
        renderRolls(renderExpressionSet(rolls, reducer), result, reducer);
      case DiceReduceResult(DiceFilterableResult(rolls, filter), reducer, result):
        renderRolls(renderDieResultFilterSet(rolls, filter, reducer), result, reducer);
      case DiceReduceResult(DiceMapeableResult(rolls, functor), reducer, result):
        renderRolls(renderDieResultMapSet(rolls, functor, reducer), result, reducer);
      case UnaryOpResult(Negate, expr, result):
        div(["class" => "unop"], [
          new RollDetailsView(expr).asNode()
        ]);
    };
  }

  function renderRollFilterResult(d: DieResultFilter) {
    return switch d {
      case Keep(roll):
        div(["class" => "keep"], renderRollResult(roll));
      case Discard(roll):
        div(["class" => "discard"], renderRollResult(roll));
    };
  }

  function renderRollMapResult(d: DiceResultMapped) {
    return switch d {
      case Rerolled(rerolls):
        var seq = rerolls.slice(0, -1).map(renderDie).map(function(n) {
          return div(["class" => "discard"], n);
        });
        seq.push(div(["class" => "keep"], renderDie(rerolls.last())));
        div(["class" => "rerolled"], seq.reversed());
      case Exploded(explosions):
        div(["class" => "exploded"], explosions.reversed().map(renderDie).map(function(n) {
          return div(["class" => "keep"], n);
        }));
      case Normal(roll):
        div(["class" => "normal"], renderDie(roll));
    };
  }

  function instersperseOp(reducer) {
    var op = switch reducer { case Sum: "+"; case _: ","; };
    return function() return div(["class" => "comma"], op);
  }

  function renderExpressionSet(rolls: Array<RollResult>, reducer)
    return rolls.map(renderRollResult).interspersef(instersperseOp(reducer));

  function renderDieResultMapSet(rolls: Array<DiceResultMapped>, functor, reducer)
    return rolls.map(renderRollMapResult).interspersef(instersperseOp(reducer));

  function renderDieResultFilterSet(rolls: Array<DieResultFilter>, filter, reducer)
    return rolls.map(renderRollFilterResult).interspersef(instersperseOp(reducer));

  function renderRolls(rolls: Array<VNode>, result: Int, reducer) {
    return if(rolls.length == 1) {
      div(["class" => "reduce"], rolls.concat(displayReducer(reducer)));
    } else {
      details(result, function() {
        var content = [
          div(
            ["class" => "dice-set"],
            rolls
          )
        ];
        return div(["class" => "reduce"], content.concat(displayReducer(reducer)));
      });
    }
  }

  function displayReducer(reducer) {
    return switch reducer {
      case Average: div("average");
      case Median: div("median");
      case Min: div("min");
      case Max: div("max");
      case Sum: dummy();
    };
  }

  function renderDie(die: DieResult) {
    var r = 'roll${Math.ceil(Math.random() * 5)}';
    return switch die.sides {
      case 6:
        div(["class" => "die-container"], div(["class" => 'die-icon roll $r'], [i(["class" => 'df-dot-d6-${die.result}'])]));
      case 2, 4, 8, 10, 12, 20:
        div(["class" => "die-container"], div(["class" => 'die-icon roll $r'], [i(["class" => 'df-d${die.sides}-${die.result}'])]));
      case _:
        details(die.result, function() {
          return div(["class" => "die"], [
            div(["class" => "d"], "d"),
            div(["class" => "X"], die.sides == 100 ? "%" : "" + die.sides)
          ]);
        });
    }
  }

  function renderOp(op: DiceBinOp) return switch op {
    case Sum: "+";
    case Difference: "-";
    case Multiplication: "×";
    case Division: "÷";
  }

  function details(result: Int, gen: Void -> VNode) {
    return div(["class" => "pair"], [
      div(["class" => "result"], '$result'),
      div(["class" => "details"], gen()),
    ]);
  }
}
