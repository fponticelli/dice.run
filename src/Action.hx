import dr.DiceExpression;
import thx.Unit;

enum Action {
  EvaluateExpression(expr: String);
  UpdateSeed(value: Int);
}
