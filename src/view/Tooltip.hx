package view;

import doom.core.VNode;
import doom.core.VNodes;
import doom.html.Html.*;

class Tooltip {
  public static function render(el: VNode, content: VNodes) {
    return div(["class" => "tooltip"],
      [
        el,
        span(content)
      ]
    );
  }
}
