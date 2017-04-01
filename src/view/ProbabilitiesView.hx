package view;

import ProbabilitiesResult;
import dr.DiceExpression;
import doom.html.Html.*;
using thx.format.NumberFormat;
import js.html.Worker;
using thx.Strings;
import haxe.ds.Option;
import Loc.msg;

class ProbabilitiesView extends doom.html.Component<ProbabilitiesViewProps> {
  static var ROUND = 1;
  static var barHeight = 100.0;
  static var STORAGE_PREFIX = "dice.run-expression:";
  public static var worker: js.html.Worker = {
    var worker = new js.html.Worker("worker.js");
    var storage = js.Browser.window.localStorage;
    worker.onmessage = function(e) {
      var expr = e.data.expression;
      var p = ProbabilitiesResult.fromObject(e.data.results);
      storage.setItem('$STORAGE_PREFIX$expr', haxe.Json.stringify(e.data.results));
      if(null != view && expr == view.props.expression) {
        view.update({
          expression: view.props.expression,
          parsed: view.props.parsed,
          probabilities: p,
          selected: view.props.selected
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
  public static var view: ProbabilitiesView;

  public static function post(expr: String) {
    worker.postMessage({ expression: expr });
  }

  public function new(props: ProbabilitiesViewProps) {
    super(props, []);
    view = this;
    post(props.expression);
  }

  override function migrationFields() {
    return super.migrationFields().concat(["worker"]);
  }

  override function render() {
    var stats = props.probabilities.stats();
    var min = stats.minValue,
        max = stats.maxValue;
    var range = max - min;
    var bucketSize = findBucketSize(range);
    // trace(exponent, magnitude);
    var ps = msg.probabilitiesStats;
    if(bucketSize > 1) {
      stats = props.probabilities.bucket(bucketSize).stats();
      ps = msg.probabilitiesStatsWithBucket;
    }

    var f = NumberFormat.number.bind(_, 0);
    return div(["class" => "bars"],  [
      div(["class" => "stats"],
        ps
          .replace("$minValue", f(min))
          .replace("$maxValue", f(max))
          .replace("$count", f(stats.count))
          .replace("$bucketSize", f(bucketSize))
      ),
      div(["class" => "probabilities-container"], [
        div(["class" => "probabilities"], [
          div(["class" => "barchart"], stats.map(renderAtLeast.bind(bucketSize))),
          div(["class" => "barchart"], stats.map(renderProb.bind(bucketSize))),
          div(["class" => "barchart"], stats.map(renderAtMost.bind(bucketSize))),
        ]),
        div(["class" => "probabilities-labels"], [
          div(["class" => "label"], Loc.msg.atLeast),
          div(["class" => "label"], Loc.msg.probabilities),
          div(["class" => "label"], Loc.msg.atMost),
        ])
      ])
    ]);
  }

  function findBucketSize(range) {
    var threshold = 100;
    if(range <= threshold) return 1;
    var sizes = [2, 5, 10, 20, 25, 50, 100],
        multiplier = 100,
        curMultiplier = 1;
    while(true) {
      for(v in sizes) {
        var vm = curMultiplier * v;
        if(range / vm <= threshold) return vm;
      }
      curMultiplier *= multiplier;
    }
  }

  override function willMount() {
    view = this;
  }

  override function willUnmount() {
    view = null;
  }

  function mouseEnter(value: Int) {
    return function() {
      update({
        expression: props.expression,
        parsed: props.parsed,
        probabilities: props.probabilities,
        selected: Some(value)
      });
    }
  }

  function renderProb(bucketSize: Int, sample: Sample) {
    return div(["class" => [
      "bar-container" => true,
      "selected" => isSelected(sample.value)
    ],
      "mouseenter" => mouseEnter(sample.value),
      "click" => mouseEnter(sample.value)
    ], [
      div(["class" => "label"], div(["class" => "text"], formatValue(bucketSize, sample.value))),
      div(["class" => "bar", "style" => 'height: ${height(sample.maxPercent*barHeight)}'], ""),
      div(["class" => "percent"], div(["class" => "text"], percent(sample.percent))),
    ]);
  }

  function isSelected(value) return switch props.selected {
    case Some(v): v == value;
    case None: false;
  }

  function renderAtMost(bucketSize: Int, sample: Sample) {
    return div(["class" => [
      "bar-container" => true,
      "selected" => isSelected(sample.value)
    ],
      "mouseenter" => mouseEnter(sample.value),
      "click" => mouseEnter(sample.value)
    ], [
      div(["class" => "label"], div(["class" => "text"], formatValue(bucketSize, sample.value))),
      div(["class" => "bar", "style" => 'height: ${height(sample.accPercent*barHeight)}'], ""),
      div(["class" => "percent"], div(["class" => "text"], percent(sample.accPercent))),
    ]);
  }

  function renderAtLeast(bucketSize: Int, sample: Sample) {
    var v = sample.revPercent;
    return div(["class" => [
      "bar-container" => true,
      "selected" => isSelected(sample.value)
    ],
      "mouseenter" => mouseEnter(sample.value),
      "click" => mouseEnter(sample.value)
    ], [
      div(["class" => "label"], div(["class" => "text"], formatValue(bucketSize, sample.value))),
      div(["class" => "bar", "style" => 'height: ${height(v*barHeight)}'], ""),
      div(["class" => "percent"], div(["class" => "text"], percent(v))),
    ]);
  }

  function formatValue(bucketSize: Int, value: Int) {
    return if(bucketSize == 1) {
      '$value';
    } else {
      var m = (value - 1)*bucketSize;
      '$m-${m+bucketSize-1}';
    }
  }

  function height(v: Float) {
    return Math.round(v*10)/10 + "px";
  }

  static function percent(v: Float) {
    var f = (v*100).fixed(ROUND).split(".");
    f[1] = f[1].trimCharsRight("0");
    f = f.filter(Strings.hasContent);
    return f.join(".") + "%";
  }
}

typedef ProbabilitiesViewProps = {
  expression: String,
  parsed: DiceExpression,
  probabilities: ProbabilitiesResult,
  selected: Option<Int>
}
