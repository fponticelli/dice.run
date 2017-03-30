import thx.stream.Reducer.Middleware.*;
import State;
using thx.Strings;

class Middleware {
  public function new() {}

  public function use()
    return empty() + updateUrl;

  public function updateUrl(state: State) {
    switch state.expression {
      case Parsed(source, normalized, expr):
        js.Browser.location.hash = '/d/${source.replace(" ", "_")}';
      case _:
    }
  }
}
