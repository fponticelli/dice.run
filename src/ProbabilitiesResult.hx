using thx.Iterators;

class ProbabilitiesResult {
  public var map: Map<Int, Int>;
  public var count: Int;
  public function new() {
    map = new Map();
    count = 0;
  }

  public function add(value: Int) {
    if(map.exists(value))
      map.set(value, map.get(value) + 1);
    else
      map.set(value, 1);
    count++;
  }

  public function toObject() {
    var o = {};
    for(key in map.keys())
      Reflect.setField(o, untyped key, map.get(key));
    return {
      count: count,
      values: o
    };
  }

  public static function fromObject(o: {}) {
    var p = new ProbabilitiesResult();
    p.count = Reflect.field(o, "count");
    var ob = Reflect.field(o, "values");
    var fields = Reflect.fields(ob);
    for(f in fields)
      p.map.set(Std.parseInt(f), Reflect.field(ob, f));
    return p;
  }

  public function stats() {
    return new ProbabilitiesStats(map, count);
  }
}

class ProbabilitiesStats {
  public var minValue(default, null): Int;
  public var maxValue(default, null): Int;
  public var minWeight(default, null): Int;
  public var maxWeight(default, null): Int;
  public var total(default, null): Int;
  public var count(default, null): Int;

  var table: Map<Int, Int>;
  public function new(table: Map<Int, Int>, count: Int) {
    this.table = table;
    this.count = count;
    if(count == 0) return;
    var samples = table.keys().toArray();
    var first = samples.shift();
    maxValue = minValue = first;
    minWeight = maxWeight = total = table.get(first);
    for(value in samples) {
      var weight = table.get(value);
      if(value < minValue) minValue = value;
      if(value > maxValue) maxValue = value;
      if(weight < minWeight) minWeight = weight;
      if(weight > maxWeight) maxWeight = weight;
      total += weight;
    }
  }

  public function map<T>(f: Sample -> T): Array<T> {
    var accWeight = 0;
    var revWeight = total;
    var sample = new Sample(0, 0, accWeight, revWeight, minValue, maxValue, minWeight, maxWeight, total);
    var buf = [];
    for(i in minValue...maxValue+1) {
      sample.value = i;
      sample.weight = table.exists(i) ? table.get(i) : 0;
      accWeight += sample.weight;
      sample.accWeight = accWeight;
      sample.revWeight = revWeight;
      revWeight -= sample.weight;
      buf.push(f(sample));
    }
    return buf;
  }
}

class Sample {
  public var value: Int;
  public var weight: Int;
  public var accWeight: Int;
  public var revWeight: Int;
  public var minValue: Int;
  public var maxValue: Int;
  public var minWeight: Int;
  public var maxWeight: Int;
  public var total: Int;
  public var percent(get, null): Float;
  public var maxPercent(get, null): Float;
  public var accPercent(get, null): Float;
  public var revPercent(get, null): Float;

  public function new(value: Int, weight: Int, accWeight: Int, revWeight: Int, minValue: Int, maxValue: Int, minWeight: Int, maxWeight: Int, total: Int) {
    this.value = value;
    this.weight = weight;
    this.accWeight = accWeight;
    this.revWeight = revWeight;
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.minWeight = minWeight;
    this.maxWeight = maxWeight;
    this.total = total;
  }

  function get_percent()
    return weight / total;

  function get_maxPercent()
    return percent / (maxWeight / total);

  function get_accPercent()
    return accWeight / total;

  function get_revPercent()
    return revWeight / total;
}
