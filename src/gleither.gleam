import gleam/option.{type Option, None, Some}

pub type Either(left, right) {
  Left(val: left)
  Right(val: right)
}

pub fn is_left(either: Either(left, right)) -> Bool {
  case either {
    Left(_) -> True
    Right(_) -> False
  }
}

pub fn is_right(either: Either(left, right)) -> Bool {
  !is_left(either)
}

pub fn get(either: Either(left, right)) -> Option(left) {
  case either {
    Left(val) -> Some(val)
    Right(_) -> None
  }
}

pub fn get_right(either: Either(left, right)) -> Option(right) {
  case either {
    Right(val) -> Some(val)
    Left(_) -> None
  }
}

pub fn map(
  either: Either(left, right),
  func: fn(left) -> new,
) -> Either(new, right) {
  case either {
    Left(l) -> Left(func(l))
    Right(r) -> Right(r)
  }
}

pub fn map_right(
  either: Either(left, right),
  func: fn(right) -> new,
) -> Either(left, new) {
  case either {
    Right(r) -> Right(func(r))
    Left(l) -> Left(l)
  }
}

pub fn flatten(
  either: Either(Either(left, right), right),
) -> Either(left, right) {
  case either {
    Left(inner) -> inner
    Right(r) -> Right(r)
  }
}

pub fn flatten_right(
  either: Either(left, Either(left, right)),
) -> Either(left, right) {
  case either {
    Right(inner) -> inner
    Left(l) -> Left(l)
  }
}

pub fn flat_map(
  either: Either(left, right),
  func: fn(left) -> Either(left, right),
) -> Either(left, right) {
  either
  |> map(func)
  |> flatten
}

pub fn flat_map_right(
  either: Either(left, right),
  func: fn(right) -> Either(left, right),
) -> Either(left, right) {
  either
  |> map_right(func)
  |> flatten_right
}

pub fn swap(either: Either(left, right)) -> Either(right, left) {
  case either {
    Right(r) -> Left(r)
    Left(l) -> Right(l)
  }
}
