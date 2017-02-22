import react.React;
import react.ReactComponent;
import react.ReactDOM;
import js.Browser;

class Main extends ReactComponent {

  static public function main() {
    ReactDOM.render(React.createElement(Main), Browser.document.getElementById('main'));
  }

  override function render() {
    var cname = 'foo';
    return React.createElement('div', {className:cname}, ["content goes here"]);
  }
}