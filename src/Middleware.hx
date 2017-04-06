import thx.stream.Reducer.Middleware.*;
import State;
using thx.Strings;

class Middleware {
  var current = null;
  public function new() {}

  public function use()
    return empty() + updateUrl;

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
}
