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
    var state: State = { expression: Unparsed("") };
    var mw = new Middleware();
    var store = new Store(new Property(state), Reducer.reduce, mw.api);
    var app = new Main(store);

    Doom.browser.mount(app, Query.find("#main"));
    store.stream()
      .next(function(_) app.update(store))
      .run();

    function dispatchHash() {
      var h = js.Browser.location.hash.trimCharsLeft("#/");
      // trace(h);
      if(h.startsWith("d/")) {
        store.dispatch(EvaluateExpression(prettify(h.substring(2))));
      } else if(h == "") {
        store.dispatch(EvaluateExpression("4d6 drop 1")); // sample
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
        case Parsed(_, _, e): Some(e);
        case _: None;
      }).asNode(),
      div(["class" => "description"], raw(markdownToHtml(Loc.description)))
    ]);
  }
}
