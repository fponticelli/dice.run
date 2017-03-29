package view;

import doom.html.Component;
import doom.html.Html.*;
import haxe.ds.Option;
import dr.DiceExpression;
using dr.RollResultExtensions;
import dr.Roller;
using thx.Arrays;
import thx.math.random.LehmerSeed;
using thx.Options;

class RollView extends Component<Option<{ expression: DiceExpression, seed: Int, updateSeed: Int -> Void }>> {
  override function render()
    return switch props {
      case None:
        dummy();
      case Some({ expression: expr, seed: seed, updateSeed: update }):
        var seeded = LehmerSeed.std(seed);
        var r = new Roller(function(sides) {
          var v = Math.floor(seeded.normalized * sides) + 1;
          seeded = seeded.next();
          return v;
        }).roll(expr);
        div(["class" => "roll-box"], [
          div(["class" => "rolling"], [
            div(["class" => "roll-result"], [
              a(["click" => roll.bind(seeded.int), "href" => "#"], '${r.getResult()}')
            ]),
            div(["class" => "roll-seed"], [
              span("seed: "),
              span([
                "class" => "text-editor",
                "input" => changeSeed,
                "contentEditable" => "true"
              ], '$seed')
            ])
          ]),
          div(["class" => "roll-details"], new RollDetailsView(r))
        ]);
    };

  function changeSeed(value: String) {
    var v = Std.parseInt(value);
    roll(v < 1 ? 1 : (v >= thx.math.Const.INT32_MAX) ? thx.math.Const.INT32_MAX-1 : v);
  }

  function roll(next: Int)
    props.map(function(v) return v.updateSeed(next));

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
