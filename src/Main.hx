import react.React;
import react.ReactComponent.ReactComponentOfState;
import react.ReactDOM;
import react.ReactMacro.jsx;
import js.Browser;

import thx.stream.Property;
import thx.stream.Store;

class Main extends ReactComponentOfState<State> {
  static public function main() {
    ReactDOM.render(jsx('<Main/>'), Browser.document.getElementById('main'));
  }

  override function render() {
    return jsx('<div className="app">todo</div>');
  }

  public function new() {
    super();
    this.state = { page: DiceSimulator };
    var mw = new Middleware();
    var store = new Store(new Property(state), Reducer.reduce, mw.api);

    store.stream()
         .delayed(0)
         .next(function(v) setState(v))
         .run();
  }
}