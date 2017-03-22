import view.*;
import doom.html.Component;
import doom.html.Html.*;
import dots.Query;

import thx.stream.Property;
import thx.stream.Store;
import State;
import Markdown.*;
using thx.Strings;

class Main extends Component<Store<State, Action>> {
  static public function main() {
    var state: State = { expression: Unparsed(""), seed: 1234567890 };
    var mw = new Middleware();
    var store = new Store(new Property(state), Reducer.reduce, mw.api);
    var app = new Main(store);

    Doom.browser.mount(app, Query.find("#main"));
    store.stream()
      // .log()
      .next(function(_) app.update(store))
      .run();

    function dispatchHash() {
      var h = js.Browser.location.hash.trimCharsLeft("#/");
      if(h.startsWith("d/")) {
        store.dispatch(EvaluateExpression(prettify(h.substring(2))));
      } else if(h == "") {
        store.dispatch(EvaluateExpression("3d6"));
      }
    }

    js.Browser.window.onhashchange = function(e) dispatchHash();
    dispatchHash();
  }

  static function prettify(s: String) {
    return s.replace("_", " ");
  }

  override function render() {
    var state = props.get();
    return div([
      new ExpressionInput({
        dispatch: function(a) props.dispatch(a),
        expr: state.expression
      }).asNode(),
      switch state.expression {
        case Parsed(s, n, e):
          new BarChart({ expression: n, parsed: e, probabilities: new ProbabilitiesResult() }).asNode();
        case _:
          dummy();
      },
      new RollView(switch state.expression {
        case Parsed(_, _, e): Some({
          expression: e,
          seed: state.seed,
          updateSeed: function(seed: Int) props.dispatch(UpdateSeed(seed))
        });
        case _: None;
      }).asNode(),
      div(["class" => "description"], raw(markdownToHtml(Loc.description)))
    ]);
  }
}
