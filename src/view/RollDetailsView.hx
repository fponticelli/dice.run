package view;

import doom.html.Component;
import doom.html.Html.*;
import doom.core.VNode;
import dr.DiceExpression;
import dr.RollResult;
using thx.Functions;
using thx.Arrays;

/*
OneResult
LiteralResult
DiceMapResult
DiceReducerResult
BinaryOpResult
UnaryOpResult
*/
class RollDetailsView extends Component<RollResult<Int>> {
  override function render() {
    return renderRollResult(props);
  }

  function renderRollResult(result: RollResult<Int>) {
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

  function renderRollFilterResult(d: DieResultFilter<Int>) {
    return switch d {
      case Keep(roll):
        div(["class" => "keep"], renderRollResult(roll));
      case Discard(roll):
        div(["class" => "discard"], renderRollResult(roll));
    };
  }

  function renderRollMapResult(d: DiceResultMapped<Int>) {
    return switch d {
      case Rerolled(rerolls):
        var seq = rerolls.slice(0, -1).map(renderDie).map(function(n) {
          return div(["class" => "discard"], n);
        });
        seq.push(div(["class" => "keep"], renderDie(rerolls.last())));
        div(["class" => "rerolled"], seq);
      case Exploded(explosions):
        div(["class" => "exploded"], explosions.map(renderDie).map(function(n) {
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

  function renderExpressionSet(rolls: Array<RollResult<Int>>, reducer)
    return rolls.map(renderRollResult).interspersef(instersperseOp(reducer));

  function renderDieResultMapSet(rolls: Array<DiceResultMapped<Int>>, functor, reducer)
    return rolls.map(renderRollMapResult).interspersef(instersperseOp(reducer));

  function renderDieResultFilterSet(rolls: Array<DieResultFilter<Int>>, filter, reducer)
    return rolls.map(renderRollFilterResult).interspersef(instersperseOp(reducer));

  function renderRolls(rolls: Array<VNode>, result: Int, reducer) {
    return details(result, function() {
      var content = [
        div(
          ["class" => "dice-set"],
          rolls
        )
      ];
      switch reducer {
        case Average: content.push(div("average"));
        case Min: content.push(div("min"));
        case Max: content.push(div("max"));
        case _:
      }
      return div(["class" => "reduce"], content);
    });
  }

  function renderDie(die: DieResult<Int>) {
    return details(die.result, function() {
      return div(["class" => "die"], [
        div(["class" => "d"], "d"),
        div(["class" => "X"], die.sides == 100 ? "%" : "" + die.sides)
      ]);
    });
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