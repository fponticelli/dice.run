import view.*;
import doom.html.Component;
import doom.html.Html.*;
import dots.Query;

import thx.stream.Property;
import thx.stream.Store;
import State;
using thx.Strings;
import Loc.msg;

class Main extends Component<Store<State, Action>> {
  static public function main() {
    var state: State = { expression: Unparsed(""), seed: 1234567890, useSeed: false };
    var mw = new Middleware();
    var store = new Store(new Property(state), Reducer.reduce, mw.use());
    var app = new Main(store);

    Doom.browser.mount(app, Query.find("#main"));
    store.stream()
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
    return div(["class" => "content"], [
      div(["class" => "header"], [
        div(["class" => "ribbon"],
          a(["href" => msg.jumpersideasLink], [
            span(["class" => "prefix"], msg.asConfabulatedOn),
            br(),
            span(["class" => "domain"], msg.jumpersideas)
          ])),
        new ExpressionInput({
          dispatch: function(a) props.dispatch(a),
          expr: state.expression
        }).asNode(),
        new RollView(switch state.expression {
          case Parsed(_, _, e): Some({
            expression: e,
            seed: state.seed,
            updateSeed: function(seed: Int) props.dispatch(UpdateSeed(seed)),
            changeUseSeed: function(value: Bool) props.dispatch(ToggleUseSeed(value)),
            useSeed: state.useSeed
          });
          case _: None;
        }).asNode(),
      ]),
      div(["class" => "body"], [
        switch state.expression {
          case Parsed(s, n, e):
            new ProbabilitiesView({
              expression: n,
              parsed: e,
              probabilities: None,
              selected: None
            }).asNode();
          case _:
            dummy();
        },
        div(["class" => "description text-content"], raw(markdownToHtml(Loc.description))),
        div(["class" => "footer text-content"], raw(markdownToHtml(Loc.footer)))
      ])
    ]);
  }

  public static function markdownToHtml(s: String) {
    var converter = untyped __js__("new showdown.Converter")();
    return converter.makeHtml(s);
  }
}
