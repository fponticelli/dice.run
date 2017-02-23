package view;

import doom.html.Component;
import doom.html.Html.*;
import haxe.ds.Option;
import dr.DiceExpression;
using dr.DiceExpressionExtensions;
import dr.Roller;
import thx.Unit;

class RollView extends Component<Option<DiceExpression<Unit>>> {
  override function render()
    return switch props {
      case None:
        div("nothing to roll");
      case Some(expr):
        var roller = Roller.int(function(sides) {
          return 1 + Math.floor(Math.random() * sides);
        });
        var r = roller.roll(expr);
        div(["class" => "roll-box"], [
          div(["class" => "roll-result"], '${r.getMeta()}'),
          button(["click" => roll], "roll again")
        ]);
    };

  function roll()
    update(props);
}