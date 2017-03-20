package view;

import thx.Timer;
import dr.Roller;
import dr.DiceExpression;
import dr.DiceParser;
using dr.RollResultExtensions;

class DiceWorker {
  public static var RUNTIME = 100;
  public static var RUNDELAY = 100;
  public static var MAXRUNS = 10000000;
  public static var cancel = function(){};

  public static var cache: Map<String, DiceWorkerData> = new Map();
  @:expose("onmessage")
  public static function onMessage(e) {
    if(e.data.expression != null)
      evaluate(e.data.expression);
    else if(e.data.init != null)
      init(e.data.init);
  }

  static function init(data) {
    var map = new Map();
    for(f in Reflect.fields(data)) {
      var dwd = new DiceWorkerData(f);
      var res = Reflect.field(data, f);
      dwd.results = ProbabilitiesResult.fromObject(res);
      // dwd.results.count = res.count;
      map.set(f, dwd);
    }
    cache = map;
  }

  static function evaluate(expr) {
    cancel();
    var worker = cache.get(expr);
    if(null == worker) {
      worker = new DiceWorkerData(expr);
      cache.set(worker.exprString, worker);
    }
    if(worker.results.count >= MAXRUNS) {
      send(worker);
    } else {
      run(worker);
    }
  }

  static function run(worker: DiceWorkerData) {
    var endOn = Timer.time() + RUNTIME;
    while(true) {
      worker.roll();
      if(worker.results.count == MAXRUNS) break;
      if(Timer.time() >= endOn) break;
    }
    send(worker);
    if(worker.results.count < MAXRUNS) {
      cancel = Timer.delay(run.bind(worker), RUNDELAY);
    }
  }

  public static function send(worker: DiceWorkerData) {
    (untyped postMessage)({ expression: worker.exprString, results: worker.results.toObject() });
  }
}

class DiceWorkerData {
  public var results: ProbabilitiesResult;
  public var exprString: String;
  var expr: DiceExpression;
  var roller: Roller;
  public function new(exprString: String) {
    this.exprString = exprString;
    this.expr = DiceParser.unsafeParse(exprString);
    this.roller = new Roller(function(sides) {
      return 1 + Math.floor(Math.random() * sides);
    });
    this.results = new ProbabilitiesResult();
  }

  inline public function roll() {
    results.add(roller.roll(expr).getResult());
  }
}
