package view;

import doom.html.Component;
import doom.html.Html.*;
import haxe.ds.Option;
import dr.DiceExpression;
import dr.DiceExpressionExtensions;
using dr.RollResultExtensions;
import dr.Roller;
using thx.Arrays;
import thx.math.random.LehmerSeed;
using thx.Options;
import Loc.msg;

class RollView extends Component<Option<{ expression: DiceExpression, seed: Int, updateSeed: Int -> Void, changeUseSeed: Bool -> Void, useSeed: Bool }>> {
  static var DISPLAY_ROLLS_THRESHOLD = 50;
  override function render()
    return switch props {
      case None:
        dummy();
      case Some({ expression: expr, seed: seed, updateSeed: update, changeUseSeed: changeUseSeed, useSeed: useSeed }):
        var r, rollDice;
        if(useSeed) {
          var seeded = LehmerSeed.std(seed);
          r = new Roller(function(sides) {
            var v = Math.floor(seeded.normalized * sides) + 1;
            seeded = seeded.next();
            return v;
          }).roll(expr);
          rollDice = roll.bind(seeded.int);
        } else {
          r = new Roller(function(sides) {
            return Math.floor(Math.random() * sides) + 1;
          }).roll(expr);
          rollDice = function() {
            this.update(props);
          }
        }
        div(["class" => "roll-box"], [
          div(["class" => "rolling"], [
            div(["class" => "roll-result"], [
              a(["click" => rollDice, "href" => "#"], '${r.getResult()}')
            ]),
            renderSeed(seed, useSeed)
          ]),
          if(DiceExpressionExtensions.calculateBasicRolls(expr) > DISPLAY_ROLLS_THRESHOLD) {
            div(["class" => "roll-details"], msg.tooManyDice);
          } else {
            div(["class" => "roll-details"], new RollDetailsView(r));
          }
        ]);
    };

  function renderSeed(seed: Int, useSeed: Bool) {
    if(useSeed) {
      return div(["class" => "roll-seed"], [
          label([
            input(["type" => "checkbox", "checked" => useSeed, "change" => changeUseSeed]),
            span(' ${msg.useSeed}: '),
          ]),
          span([
            "class" => "text-editor",
            "input" => changeSeed,
            "contentEditable" => "true"
          ], '$seed')
        ]);
    } else {
      return div(["class" => "roll-seed"], [
          label([
            input(["type" => "checkbox", "checked" => useSeed, "change" => changeUseSeed]),
            span(' ${msg.useSeed}')
          ])
        ]);
    }
  }

  function changeUseSeed(value: Bool)
    props.map(function(v) return v.changeUseSeed(value));

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
