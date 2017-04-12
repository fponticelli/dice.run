package view;

import doom.core.VNode;
import doom.core.VNodes;
import doom.html.Html.*;

class Tooltip {
  public static function render(displayTooltip: Bool, el: VNode, content: VNodes) {
    var children = [el];
    if(displayTooltip)
      children.push(div(["class" => "tooltip"], content));
    return div(["class" => "tooltip-container"], children);
  }
}
