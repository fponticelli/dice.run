package view;

import doom.html.Component;
import doom.html.Html.*;

class Editable extends doom.html.Component<{ value: String, change: String -> Void, focus: Bool }> {
  override function render() {
    return span([
        "class" => "text-editor",
        "contentEditable" => "true",
        "input" => onInput,
      ], props.value);
  }

  function onInput(input: js.html.DivElement)
    props.change(input.textContent);
}
