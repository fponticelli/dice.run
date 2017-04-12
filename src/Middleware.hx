import thx.stream.Reducer.Middleware.*;
import thx.stream.Reducer.MiddlewareF;
import State;
using thx.Strings;

class Middleware {
  var current = null;
  public function new() {}

  public function use() {
    var f: MiddlewareF<State, Action> = empty() + updateUrl + saveHideTooltip;
    return function(state: State, action: Action, dispatch) {
      switch action {
        case Composite(a, b):
          f(state, a, dispatch);
          f(state, b, dispatch);
        case other:
          f(state, other, dispatch);
      }
    }
  }

  public function updateUrl(state: State) {
    switch state.expression {
      case Parsed(source, normalized, expr):
        var hash = '/d/${source.replace(" ", "_")}';
        if(current == hash) return;
        current = hash;
        updateLocation(current);
        updateGoogleAnalytics(current);
      case _:
    }
  }

  public static function updateLocation(s: String)
    js.Browser.location.hash = s;

  public static function updateGoogleAnalytics(s: String) {
    (untyped ga)('set', 'page', s);
    (untyped ga)('send', 'pageview');
  }

  public static function saveHideTooltip(a: Action) {
    switch a {
      case HideExpressionTooltip:
        var storage = js.Browser.window.localStorage;
        storage.setItem("dice.run-hide-expression-tooltip", "true");
      case HideRollTooltip:
        var storage = js.Browser.window.localStorage;
        storage.setItem("dice.run-hide-roll-tooltip", "true");
      case _:
    }
  }
}
