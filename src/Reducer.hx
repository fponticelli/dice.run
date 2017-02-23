using thx.Objects;

class Reducer {
  public static function reduce(state: State, action: Action) {
    return switch action {
      case _:
        state;
    };
  }
}