package view;

import doom.html.Component;
import doom.html.Html.*;
import haxe.ds.Option;
import dr.DiceExpression;
using dr.RollResultExtensions;
import dr.Roller;
using thx.Arrays;

class RollView extends Component<Option<DiceExpression>> {
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
          button(["click" => roll], "roll again"),
          div(["class" => "roll-result"], '${r.getResult()}'),
          div(["class" => "roll-details"], new RollDetailsView(r))
        ]);
    };

  function roll()
    update(props);

  override function didMount()
    rollEffect();

  override function didUpdate()
    rollEffect();

  function rollEffect() {
    var x;
    dots.Query.select(".roll").each(function(el) {
      for(i in 1...6)
        dots.Dom.removeClass(el, 'roll${i}');
      x = el.offsetWidth;
      var r = Math.ceil(Math.random() * 5);
      dots.Dom.addClass(el, 'roll$r');
    });
    return x; // just try to keep the side effect so that the animation refreshes
  }
}
