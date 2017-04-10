package view;

import doom.html.Component;
import doom.html.Html.*;
import js.Browser.*;

class Editable extends doom.html.Component<{ value: String, change: String -> Void, focus: Bool }> {
  static var range = { start: 1000, end: 1000 };
  static var firstFocus = true;
  override function render() {
    return input([
      "class" => "text-editor",
      "keyup" => onKeyUp,
      "value" => props.value,
      "focus" => onFocus
    ]);
  }

  override function didMount()
    selectRange(cast element);

  override function didUpdate()
    selectRange(cast element);

  function onKeyUp(content: String) {
    if(content == props.value) return;
    var input: js.html.InputElement = cast element;
    range = { start: input.selectionStart, end: input.selectionEnd };
    props.change(content);
  }

  function onFocus(input: js.html.InputElement) {
    input.setSelectionRange(0, input.value.length);
  }

  static function selectRange(input: js.html.InputElement) {
    if(firstFocus) {
      input.focus();
      firstFocus = false;
    }
    if(null == range || input != document.activeElement) return;
    input.setSelectionRange(range.start, range.end);
  }
}
