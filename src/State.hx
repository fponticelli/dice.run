import dr.DiceExpression;
import thx.Unit;

typedef State = {
  page: PageView
}

enum PageView {
  DiceSimulator(expr: Expression);
}

enum Expression {
  Unparsed(src: String);
  Parsed(src: String, expr: DiceExpression<Unit>);
  Error(src: String, message: String);
}