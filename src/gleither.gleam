import gleam/list
import gleam/option.{type Option, None, Some}

/// monad representing a Left or Right
pub type Either(left, right) {
  /// left
  Left(val: left)
  /// right
  Right(val: right)
}

/// returns True if the supplied value is a Left
///```gleam
///: assert gleither.is_left(gleither.Left(1))
///```
pub fn is_left(either: Either(left, right)) -> Bool {
  !is_right(either)
}

/// returns True if the supplied value is a Right
///```gleam
///: assert gleither.is_right(gleither.Right(1))
///```
pub fn is_right(either: Either(left, right)) -> Bool {
  case either {
    Left(_) -> False
    Right(_) -> True
  }
}

/// get the value of a Left or None
///```gleam
///: let assert option.Some(1) = gleither.get_left(gleither.Left(1))
///```
pub fn get_left(either: Either(left, right)) -> Option(left) {
  case either {
    Left(val) -> Some(val)
    Right(_) -> None
  }
}

/// get the value of a Right or None
///```gleam
///: let assert option.Some(1) = gleither.get_right(gleither.Right(1))
///```
pub fn get_right(either: Either(left, right)) -> Option(right) {
  case either {
    Right(val) -> Some(val)
    Left(_) -> None
  }
}

/// alias for get_right
/// get the value of a Right or None
///```gleam
///: let assert option.Some(1) = gleither.get(gleither.Right(1))
///: let assert option.None = gleither.get(gleither.Left(1))
///```
pub const get = get_right

/// get the value of a Left or default
///```gleam
///: assert gleither.get_left_with_default(gleither.Left(1), -1) == 1
///: assert gleither.get_left_with_default(gleither.Right(1), -1) == -1
///```
pub fn get_left_with_default(either: Either(left, right), default: left) -> left {
  either
  |> get_left()
  |> option.unwrap(default)
}

/// get the value of a Right or default
///```gleam
///: assert gleither.get_right_with_default(gleither.Right(1), -1) == 1
///: assert gleither.get_right_with_default(gleither.Left(1), -1) == -1
///```
pub fn get_right_with_default(
  either: Either(left, right),
  default: right,
) -> right {
  either
  |> get_right()
  |> option.unwrap(default)
}

/// alias for get_right_with_default
///```gleam
///: assert gleither.get_with_default(gleither.Right(1), -1) == gleither.get_right_with_default(gleither.Right(1), -1)
///: assert gleither.get_with_default(gleither.Left(1), -1) == gleither.get_right_with_default(gleither.Left(1), -1)
///```
pub const get_with_default = get_right_with_default

/// apply a function to the Left or preserve the Right
///```gleam
///: let assert gleither.Left(2) = gleither.map_left(gleither.Left(1), int.add(_, 1)) 
///: let assert gleither.Right(1) = gleither.map_left(gleither.Right(1), int.add(_, 1)) 
///```
pub fn map_left(
  either: Either(left, right),
  func: fn(left) -> new,
) -> Either(new, right) {
  case either {
    Left(l) -> Left(func(l))
    Right(r) -> Right(r)
  }
}

/// apply a function to the Right or preserve the Left
///```gleam
///: let assert gleither.Left(1) = gleither.map_right(gleither.Left(1), int.add(_, 1)) 
///: let assert gleither.Right(2) = gleither.map_right(gleither.Right(1), int.add(_, 1)) 
///```
pub fn map_right(
  either: Either(left, right),
  func: fn(right) -> new,
) -> Either(left, new) {
  case either {
    Right(r) -> Right(func(r))
    Left(l) -> Left(l)
  }
}

/// alias for map_right
///```gleam
///: let assert gleither.Left(1) = gleither.map(gleither.Left(1), int.add(_, 1)) 
///: let assert gleither.Right(2) = gleither.map(gleither.Right(1), int.add(_, 1)) 
///```
pub const map = map_right

/// map either potential value
///```gleam
///: let assert gleither.Left(2) = gleither.full_map(gleither.Left(1), int.add(_, 1), int.add(_, 1)) 
///: let assert gleither.Right(2) = gleither.full_map(gleither.Right(1), int.add(_, 1), int.add(_, 1)) 
///```
pub fn full_map(
  either: Either(left, right),
  left_func: fn(left) -> new_left,
  right_func: fn(right) -> new_right,
) -> Either(new_left, new_right) {
  either
  |> map_left(left_func)
  |> map_right(right_func)
}

/// flatten a nested Left
///```gleam
///: let assert gleither.Left(1) = gleither.flatten_left(gleither.Left(gleither.Left(1))) 
///```
pub fn flatten_left(
  either: Either(Either(left, right), right),
) -> Either(left, right) {
  case either {
    Left(inner) -> inner
    Right(r) -> Right(r)
  }
}

/// flatten a nested Right
///```gleam
///: let assert gleither.Right(1) = gleither.flatten_right(gleither.Right(gleither.Right(1))) 
///```
pub fn flatten_right(
  either: Either(left, Either(left, right)),
) -> Either(left, right) {
  case either {
    Right(inner) -> inner
    Left(l) -> Left(l)
  }
}

/// alias for flatten_right
///```gleam
///: let assert gleither.Right(1) = gleither.flatten_right(gleither.Right(gleither.Right(1))) 
///```
pub const flatten = flatten_right

/// flatten both
///```gleam
///: let assert gleither.Left(1) = gleither.flatten_both(gleither.Left(gleither.Left(1))) 
///: let assert gleither.Right(1) = gleither.flatten_both(gleither.Right(gleither.Right(1))) 
///```
pub fn flatten_both(
  either: Either(Either(left, right), Either(left, right)),
) -> Either(left, right) {
  case either {
    Right(inner) -> inner
    Left(inner) -> inner
  }
}

/// map and flatten a Left
///```gleam 
///: let assert gleither.Left(2) =
///: gleither.Left(1)
///: |> gleither.flat_map_left(fn(x) { gleither.Left(x + 1) })
///```
pub fn flat_map_left(
  either: Either(left, right),
  func: fn(left) -> Either(left_prime, right),
) -> Either(left_prime, right) {
  either
  |> map_left(func)
  |> flatten_left
}

/// map and flatten a Right
///```gleam 
///: let assert gleither.Right(2) =
///: gleither.Right(1)
///: |> gleither.flat_map_right(fn(x) { gleither.Right(x + 1) })
///```
pub fn flat_map_right(
  either: Either(left, right),
  func: fn(right) -> Either(left, right_prime),
) -> Either(left, right_prime) {
  either
  |> map_right(func)
  |> flatten_right
}

/// alias for flat_map_right
///```gleam 
///: let assert gleither.Right(2) =
///: gleither.Right(1)
///: |> gleither.flat_map(fn(x) { gleither.Right(x + 1) })
///```
pub const flat_map = flat_map_right

/// flat_map either potential value
///```gleam
///: let assert gleither.Left(2) =
///: gleither.Left(1)
///: |> gleither.full_flat_map(fn(x) { gleither.Left(x + 1) }, fn(x) { gleither.Right(x * 3) })
///```
///```gleam
///: let assert gleither.Right(3) =
///: gleither.Right(1)
///: |> gleither.full_flat_map(fn(x) { gleither.Left(x + 1) }, fn(x) { gleither.Right(x * 3) })
///```
pub fn full_flat_map(
  either: Either(left, right),
  left_func: fn(left) -> Either(left_prime, right_prime),
  right_func: fn(right) -> Either(left_prime, right_prime),
) -> Either(left_prime, right_prime) {
  either
  |> map_left(left_func)
  |> map_right(right_func)
  |> flatten_both
}

/// convert a Left to a Right and vice versa
///```gleam
///: let assert gleither.Right(1) = gleither.swap(gleither.Left(1))  
///```
pub fn swap(either: Either(left, right)) -> Either(right, left) {
  case either {
    Right(r) -> Left(r)
    Left(l) -> Right(l)
  }
}

/// convert a Result to an Either, mapping Ok to Left and Error to Right
///```gleam
///: let assert gleither.Left(1) = gleither.from_result(Ok(1))  
///: let assert gleither.Right(1) = gleither.from_result(Error(1))  
///```
pub fn from_result(result: Result(left, right)) -> Either(left, right) {
  case result {
    Ok(l) -> Left(l)
    Error(r) -> Right(r)
  }
}

fn group_left_acc(
  already_packaged: List(Either(List(left), right)),
  under_construction: List(left),
  upcoming: List(Either(left, right)),
) -> List(Either(List(left), right)) {
  case upcoming {
    [] ->
      [under_construction |> list.reverse |> Left, ..already_packaged]
      |> list.reverse

    [Left(left), ..rest] ->
      group_left_acc(already_packaged, [left, ..under_construction], rest)

    [Right(right), ..rest] ->
      group_left_acc(
        [
          Right(right),
          under_construction |> list.reverse |> Left,
          ..already_packaged
        ],
        [],
        rest,
      )
  }
}

/// group consecutive Left-elements of a List(Either) into sublists,
/// converting a List(Either(left, right)) to a List(Either(List(left), right))
/// 
/// ### Example
/// 
/// group_left([Left(1), Left(5), Left(4), Right("a"), Right("b"), Left(6), Right("c"))
/// 
/// // -> [Left([1, 5, 4]), Right("a"), Left([]), Right("b"), Left([6]), Right("c"), Left([])]
pub fn group_left(
  vals: List(Either(left, right)),
) -> List(Either(List(left), right)) {
  group_left_acc([], [], vals)
}

/// group consecutive Left-elements of a List(Either) into sublists,
/// converting a List(Either(left, right)) to a List(Either(List(left), right)),
/// while discarding empty lists
/// 
/// ### Example
/// 
/// group_left([Left(1), Left(5), Left(4), Right("a"), Right("b"), Left(6), Right("c"))
/// 
/// // -> [Left([1, 5, 4]), Right("a"), Right("b"), Left([6]), Right("c")]
pub fn nonempty_group_left(
  vals: List(Either(left, right)),
) -> List(Either(List(left), right)) {
  group_left_acc([], [], vals)
  |> list.filter(fn(x) {
    case x {
      Left(y) -> !{ list.is_empty(y) }
      Right(_) -> True
    }
  })
}

fn group_right_acc(
  already_packaged: List(Either(left, List(right))),
  under_construction: List(right),
  upcoming: List(Either(left, right)),
) -> List(Either(left, List(right))) {
  case upcoming {
    [] ->
      [under_construction |> list.reverse |> Right, ..already_packaged]
      |> list.reverse

    [Right(right), ..rest] ->
      group_right_acc(already_packaged, [right, ..under_construction], rest)

    [Left(left), ..rest] ->
      group_right_acc(
        [
          Left(left),
          under_construction |> list.reverse |> Right,
          ..already_packaged
        ],
        [],
        rest,
      )
  }
}

/// group consecutive Right-elements of a List(Either) into sublists,
/// converting a List(Either(left, right)) to a List(Either(left, List(right)))
/// 
/// ### Example
/// 
/// group_right([Left(1), Left(5), Left(4), Right("a"), Right("b"), Left(6), Right("c"))
/// 
/// // -> [Right([]), Left(1), Left(5), Left(4), Right(["a", "b"]), Left(6), Right(["c"])]
pub fn group_right(
  vals: List(Either(left, right)),
) -> List(Either(left, List(right))) {
  group_right_acc([], [], vals)
}

/// group consecutive Right-elements of a List(Either) into sublists,
/// converting a List(Either(left, right)) to a List(Either(left, List(right))),
/// while discarding empty lists
/// 
/// ### Example
/// 
/// group_right([Left(1), Left(5), Left(4), Right("a"), Right("b"), Left(6), Right("c"))
/// 
/// // -> [Left(1), Left(5), Left(4), Right(["a", "b"]), Left(6), Right(["c"])]
pub fn nonempty_group_right(
  vals: List(Either(left, right)),
) -> List(Either(left, List(right))) {
  group_right_acc([], [], vals)
  |> list.filter(fn(x) {
    case x {
      Left(_) -> True
      Right(y) -> !{ list.is_empty(y) }
    }
  })
}

/// maps an Either(left, right) value to a value of a third type by applying 
/// separate Left and Right mappers that both map to the third type
pub fn resolve(
  val: Either(left, right),
  left_map: fn(left) -> new,
  right_map: fn(right) -> new,
) -> new {
  case val {
    Left(left) -> left_map(left)
    Right(right) -> right_map(right)
  }
}

/// a shorthand to list.map gleither.resolve
pub fn map_resolve(
  vals: List(Either(left, right)),
  left_map: fn(left) -> new,
  right_map: fn(right) -> new,
) -> List(new) {
  list.map(vals, resolve(_, left_map, right_map))
}

/// constructs an Either from a value and a Bool by wrapping the value with Left
/// if the Bool is False, Right if the Bool is True
pub fn from_bool(val: a, bool: Bool) -> Either(a, a) {
  case bool {
    False -> Left(val)
    True -> Right(val)
  }
}

/// constructs an Either from a value val : a and a condition fn(a) -> Bool, 
/// wrapping the value with Left or Right according to whether the condition evaluates
/// to False or True, respectively, at the value
pub fn from_condition(val: a, condition: fn(a) -> Bool) -> Either(a, a) {
  from_bool(val, condition(val))
}

/// shorthand to list.map gleither.from_condition over a list of values, creating
/// a List(Either(a, a)) from a List(a) via a condition: fn(a) -> Bool
pub fn map_from_condition(
  vals: List(a),
  condition: fn(a) -> Bool,
) -> List(Either(a, a)) {
  list.map(vals, from_condition(_, condition))
}