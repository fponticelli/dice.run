package view;

import dr.DiceExpression;
import doom.html.Html.*;
using dr.RollResultExtensions;
using thx.Arrays;
using thx.Functions;
using thx.format.NumberFormat;

class BarChart extends doom.html.Component<DiceExpression> {
  override function render() {
    var pairs = probabilities();
    var total = pairs.map.fn(_.left).sum();
    var minValue = pairs.map.fn(_.right).min();
    var maxValue = pairs.map.fn(_.right).max();
    var max = pairs.map.fn(_.left).max();
    var mid = Math.floor((minValue + maxValue) / 2);
    trace(minValue, maxValue, mid);
    return div(["class" => "barchart"],
      pairs.map.fn(renderBarContainer(Math.round(_.right), _.left, mid, total, max))
    );
  }

  function renderBarContainer(value: Int, weight: Int, mid: Int, total: Float, max: Float) {
    return div(["class" => "bar-container" + (mid == value ? " middle" : "")], [
      div(["class" => "label"], div(["class" => "text"], '$value')),
      div(["class" => "bar", "style" => 'height: ${weight/max*150}px'], ""),
      div(["class" => "percent"], div(["class" => "text"], (weight/total*100).fixed(1))),
    ]);
  }

  function probabilities() {
    var roller = dr.Roller.discrete();
    var discrete = roller.roll(props).getResult();
    return discrete.weightedValues;
  }
}