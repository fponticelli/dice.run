import view.*;
import doom.html.Component;
import doom.html.Html.*;
import dots.Query;

import thx.stream.Property;
import thx.stream.Store;
import State;

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
    store.dispatch(EvaluateExpression("5d6 drop 2 + 2"));
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
              case Parsed(_, e): Some(e);
              case _: None;
            }).asNode(),
            switch expr {
              case Parsed(_, e): new BarChart(e).asNode();
              case _: dummy();
            },
          ])
        ]);
    };
  }
}