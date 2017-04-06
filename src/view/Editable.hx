package view;

import doom.html.Component;
import doom.html.Html.*;
import js.Browser.*;

class Editable extends doom.html.Component<{ value: String, change: String -> Void, focus: Bool }> {
  static var range;
  override function render() {
    return input([
      "class" => "text-editor",
      "keyup" => onKeyUp,
      "value" => props.value
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

  static function selectRange(element: js.html.InputElement) {
    if(null == range || element != document.activeElement) return;
    element.setSelectionRange(range.start, range.end);
  }
}
