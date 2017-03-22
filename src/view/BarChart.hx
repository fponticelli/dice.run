package view;

import ProbabilitiesResult;
import dr.DiceExpression;
import dr.DiceParser;
using dr.DiceExpressionExtensions;
import doom.html.Html.*;
using thx.format.NumberFormat;
import js.html.Worker;
using thx.Strings;

class BarChart extends doom.html.Component<BarChartProps> {
  static var barHeight = 100.0;
  static var STORAGE_PREFIX = "dice.run-expression:";
  public static var worker: js.html.Worker = {
    var worker = new js.html.Worker("worker.js");
    var storage = js.Browser.window.localStorage;
    worker.onmessage = function(e) {
      var expr = e.data.expression;
      var p = ProbabilitiesResult.fromObject(e.data.results);
      storage.setItem('$STORAGE_PREFIX$expr', haxe.Json.stringify(e.data.results));
      if(null != barChart && expr == barChart.props.expression) {
        barChart.update({
          expression: barChart.props.expression,
          parsed: barChart.props.parsed,
          probabilities: p
        });
      }
    };
    var collect = {};
    for(i in 0...storage.length) {
      var key = storage.key(i);
      if(!key.startsWith(STORAGE_PREFIX)) continue;
      var ob = haxe.Json.parse(storage.getItem(key));
      var k = key.substring(STORAGE_PREFIX.length);
      Reflect.setField(collect, k, ob);
    }
    worker.postMessage({ init: collect });
    worker;
  };
  public static var barChart: BarChart;

  public static function post(expr: String) {
    worker.postMessage({ expression: expr });
  }

  public function new(props: BarChartProps) {
    super(props, []);
    barChart = this;
    post(props.expression);
    // worker;
    // worker.onmessage(function(e) {
    // });
    // worker.postMessage(props.expression);
  }

  override function migrationFields() {
    return super.migrationFields().concat(["worker"]);
  }

  override function render() {
    var stats = props.probabilities.stats();
    // var total = pairs.map.fn(_.instances).sum();
    // var minValue = pairs.map.fn(_.roll).min();
    // var maxValue = pairs.map.fn(_.roll).max();
    // var max = pairs.map.fn(_.instances).max();
    // var mid = Math.floor((minValue + maxValue) / 2);

    return div(["class" => "bars"],  [
      div(["class" => "stats"], 'samples: ${NumberFormat.number(stats.count, 0)}'),
      div(["class" => "probabilities"], [
        div(["class" => "barchart"], stats.map(renderAtLeast)),
        div(["class" => "barchart"], stats.map(renderProb)),
        div(["class" => "barchart"], stats.map(renderAtMost))
      ]),
    ]);
  }

  override function willMount() {
    barChart = this;
  }

  override function willUnmount() {
    barChart = null;
  }

  function renderProb(sample: Sample) {
    return div(["class" => "bar-container"], [
      div(["class" => "label"], div(["class" => "text"], '${sample.value}')),
      div(["class" => "bar", "style" => 'height: ${sample.maxPercent*barHeight}px'], ""),
      div(["class" => "percent"], div(["class" => "text"], (sample.percent*100).fixed(1))),
    ]);
  }

  function renderAtLeast(sample: Sample) {
    return div(["class" => "bar-container"], [
      div(["class" => "label"], div(["class" => "text"], '${sample.value}')),
      div(["class" => "bar", "style" => 'height: ${sample.accPercent*barHeight}px'], ""),
      div(["class" => "percent"], div(["class" => "text"], (sample.accPercent*100).fixed(1))),
    ]);
  }

  function renderAtMost(sample: Sample) {
    var v = sample.revPercent;
    return div(["class" => "bar-container"], [
      div(["class" => "label"], div(["class" => "text"], '${sample.value}')),
      div(["class" => "bar", "style" => 'height: ${v*barHeight}px'], ""),
      div(["class" => "percent"], div(["class" => "text"], (v*100).fixed(1))),
    ]);
  }
}

typedef BarChartProps = {
  expression: String,
  parsed: DiceExpression,
  probabilities: ProbabilitiesResult
}
