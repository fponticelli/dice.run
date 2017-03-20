import view.*;
import doom.html.Component;
import doom.html.Html.*;
import dots.Query;

import thx.stream.Property;
import thx.stream.Store;
import State;
import Markdown.*;

class Main extends Component<Store<State, Action>> {
  static public function main() {
    var state: State = { page: DiceSimulator(Unparsed("")) };
    var mw = new Middleware();
    var store = new Store(new Property(state), Reducer.reduce, mw.api);
    var app = new Main(store);

    Doom.browser.mount(app, Query.find("#main"));
    store.stream()
      .next(function(_) app.update(store))
      .run();
    store.dispatch(EvaluateExpression("2d6 explode once on 4 or more")); // "2d6 drop 1")); // "5d6 drop 2 + 2"));
  }

  override function render() {
    var state = props.get();
    return switch state.page {
      case DiceSimulator(expr):
        div([
          new ExpressionInput({
            dispatch: function(a) props.dispatch(a),
            expr: expr
          }).asNode(),
          div(["class" => "split"], [
            new RollView(switch expr {
              case Parsed(_, _, e): Some(e);
              case _: None;
            }).asNode(),
            switch expr {
              case Parsed(s, n, e):
                new BarChart({ expression: n, parsed: e, probabilities: new ProbabilitiesResult() }).asNode();
              case _:
                dummy();
            },
            div(["class" => "description"], raw(markdownToHtml(Loc.description)))
          ])
        ]);
    };
  }
}
