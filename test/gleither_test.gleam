import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import gleither.{Left, Right}

pub fn main() {
  gleeunit.main()
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

pub fn full_flat_map_test() {
  Left(1)
  |> gleither.full_flat_map(fn(x) { Left(x + 1) }, fn(x) { Right(x * 3) })
  |> should.equal(Left(2))

  Right(1)
  |> gleither.full_flat_map(fn(x) { Left(x + 1) }, fn(x) { Right(x * 3) })
  |> should.equal(Right(3))
}
