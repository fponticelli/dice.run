enum Action {
  EvaluateExpression(expr: String);
  UpdateSeed(value: Int);
  ToggleUseSeed(value: Bool);
  HideExpressionTooltip;
  HideRollTooltip;
  Composite(a: Action, b: Action);
}
