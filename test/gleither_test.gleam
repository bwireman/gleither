import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import gleither.{Left, Right}
import testament
import testament/conf.{Import}

pub fn main() {
  testament.test_main_with_opts(gleeunit.main, [
    conf.ExtraImports("src/gleither.gleam", [
      Import("gleam/option", []),
      Import("gleam/int", []),
    ]),
  ])
}

pub fn is_left_test() {
  Left(1)
  |> gleither.is_left()
  |> should.be_true()

  Right(1)
  |> gleither.is_left()
  |> should.be_false()
}

pub fn get_test() {
  Left(1)
  |> gleither.get_left()
  |> should.equal(Some(1))

  Right(1)
  |> gleither.get_left()
  |> should.equal(None)
}

pub fn get_with_default_test() {
  Left(1)
  |> gleither.get_left_with_default(2)
  |> should.equal(1)

  Right(1)
  |> gleither.get_left_with_default(2)
  |> should.equal(2)
}

pub fn map_test() {
  Left(1)
  |> gleither.map_left(fn(x) { x + 1 })
  |> should.equal(Left(2))

  Right(1)
  |> gleither.map_left(fn(x) { x + 1 })
  |> should.equal(Right(1))
}

pub fn flat_map_test() {
  Left(1)
  |> gleither.flat_map_left(fn(x) { Left(x + 1) })
  |> should.equal(Left(2))

  Left(1)
  |> gleither.flat_map_left(fn(x) { Right(x + 1) })
  |> should.equal(Right(2))

  Right(1)
  |> gleither.flat_map_left(fn(x) { Left(x + 1) })
  |> should.equal(Right(1))

  Right(1)
  |> gleither.flat_map_left(fn(x) { Right(x + 1) })
  |> should.equal(Right(1))
}

pub fn is_right_test() {
  Left(1)
  |> gleither.is_right()
  |> should.be_false()

  Right(1)
  |> gleither.is_right()
  |> should.be_true()
}

pub fn get_right_test() {
  Left(1)
  |> gleither.get_right()
  |> should.equal(None)

  Right(1)
  |> gleither.get_right()
  |> should.equal(Some(1))
}

pub fn get_right_with_default_test() {
  Left(1)
  |> gleither.get_right_with_default(2)
  |> should.equal(2)

  Right(1)
  |> gleither.get_right_with_default(2)
  |> should.equal(1)
}

pub fn map_right_test() {
  Left(1)
  |> gleither.map_right(fn(x) { x + 1 })
  |> should.equal(Left(1))

  Right(1)
  |> gleither.map_right(fn(x) { x + 1 })
  |> should.equal(Right(2))
}

pub fn flat_map_right_test() {
  Right(1)
  |> gleither.flat_map_right(fn(x) { Left(x + 1) })
  |> should.equal(Left(2))

  Right(1)
  |> gleither.flat_map_right(fn(x) { Right(x + 1) })
  |> should.equal(Right(2))

  Left(1)
  |> gleither.flat_map_right(fn(x) { Left(x + 1) })
  |> should.equal(Left(1))

  Left(1)
  |> gleither.flat_map_right(fn(x) { Right(x + 1) })
  |> should.equal(Left(1))
}

pub fn swap_test() {
  Left(1)
  |> gleither.swap()
  |> should.equal(Right(1))

  Right(1)
  |> gleither.swap()
  |> should.equal(Left(1))
}

pub fn full_map_test() {
  Left(1)
  |> gleither.full_map(fn(x) { x + 1 }, fn(x) { x * 3 })
  |> should.equal(Left(2))

  Right(1)
  |> gleither.full_map(fn(x) { x + 1 }, fn(x) { x * 3 })
  |> should.equal(Right(3))
}

pub fn flatten_left_test() {
  gleither.Left(gleither.Left(1))
  |> gleither.flatten_left
  |> should.equal(gleither.Left(1))
}

pub fn flatten_right_test() {
  gleither.Right(gleither.Right(1))
  |> gleither.flatten_right
  |> should.equal(gleither.Right(1))
}

pub fn flatten_both() {
  gleither.Left(gleither.Left(1))
  |> gleither.flatten_both
  |> should.equal(gleither.Left(1))

  gleither.Right(gleither.Right(1))
  |> gleither.flatten_both
  |> should.equal(gleither.Right(1))
}

pub fn full_flat_map_test() {
  Left(1)
  |> gleither.full_flat_map(fn(x) { Left(x + 1) }, fn(x) { Right(x * 3) })
  |> should.equal(Left(2))

  Right(1)
  |> gleither.full_flat_map(fn(x) { Left(x + 1) }, fn(x) { Right(x * 3) })
  |> should.equal(Right(3))
}

pub fn from_result_test() {
  Ok(1)
  |> gleither.from_result()
  |> should.equal(Left(1))

  Error(1)
  |> gleither.from_result()
  |> should.equal(Right(1))
}

pub fn group_left_test() {
  gleither.group_left([Left(1), Left(5), Right("a"), Right("b"), Left(6)])
  |> should.equal([Left([1, 5]), Right("a"), Left([]), Right("b"), Left([6])])

  gleither.group_left([Left(1), Left(5), Right("a"), Right("b")])
  |> should.equal([Left([1, 5]), Right("a"), Left([]), Right("b"), Left([])])

  gleither.group_left([Right("a"), Right("b")])
  |> should.equal([Left([]), Right("a"), Left([]), Right("b"), Left([])])
}

pub fn nonempty_group_left_test() {
  gleither.nonempty_group_left([
    Left(1),
    Left(5),
    Right("a"),
    Right("b"),
    Left(6),
  ])
  |> should.equal([Left([1, 5]), Right("a"), Right("b"), Left([6])])

  gleither.nonempty_group_left([Left(1), Left(5), Right("a"), Right("b")])
  |> should.equal([Left([1, 5]), Right("a"), Right("b")])

  gleither.nonempty_group_left([Right("a"), Right("b")])
  |> should.equal([Right("a"), Right("b")])
}

pub fn group_right_test() {
  gleither.group_right([Right(1), Right(5), Left("a"), Left("b"), Right(6)])
  |> should.equal([Right([1, 5]), Left("a"), Right([]), Left("b"), Right([6])])

  gleither.group_right([Right(1), Right(5), Left("a"), Left("b")])
  |> should.equal([Right([1, 5]), Left("a"), Right([]), Left("b"), Right([])])

  gleither.group_right([Left("a"), Left("b")])
  |> should.equal([Right([]), Left("a"), Right([]), Left("b"), Right([])])
}

pub fn nonempty_group_right_test() {
  gleither.nonempty_group_right([
    Right(1),
    Right(5),
    Left("a"),
    Left("b"),
    Right(6),
  ])
  |> should.equal([Right([1, 5]), Left("a"), Left("b"), Right([6])])

  gleither.nonempty_group_right([Right(1), Right(5), Left("a"), Left("b")])
  |> should.equal([Right([1, 5]), Left("a"), Left("b")])

  gleither.nonempty_group_right([Left("a"), Left("b")])
  |> should.equal([Left("a"), Left("b")])
}

pub fn resolve_test() {
  gleither.resolve(Left(1), fn(x) { x + 1 }, fn(_) { 0 })
  |> should.equal(2)

  gleither.resolve(Right(Nil), fn(x) { x + 1 }, fn(_) { 0 })
  |> should.equal(0)
}

pub fn map_resolve_test() {
  gleither.map_resolve([Left(1), Right(Nil)], fn(x) { x + 1 }, fn(_) { 0 })
  |> should.equal([2, 0])
}

pub fn from_bool_test() {
  gleither.from_bool(1, False)
  |> should.equal(Left(1))

  gleither.from_bool(1, True)
  |> should.equal(Right(1))
}

pub fn from_condition_test() {
  gleither.from_condition(1, fn(x) { x > 0 })
  |> should.equal(Right(1))

  gleither.from_condition(0, fn(x) { x > 0 })
  |> should.equal(Left(0))
}

pub fn map_from_condition_test() {
  gleither.map_from_condition([-1, 0, 1, 0], fn(x) { x > 0 })
  |> should.equal([Left(-1), Left(0), Right(1), Left(0)])
}
