enum Action {
  EvaluateExpression(expr: String);
  UpdateSeed(value: Int);
  ToggleUseSeed(value: Bool);
  HideTooltip;
  Composite(a: Action, b: Action);
}
