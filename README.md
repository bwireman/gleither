# Gleither ↔️

A small data-structure for representing Left or Right. Written in the excellent [gleam ✨](https://gleam.run/) language. Supporting both Erlang & Javascript targets

[![test](https://github.com/bwireman/gleither/actions/workflows/test.yml/badge.svg)](https://github.com/bwireman/gleither/actions/workflows/test.yml)
[![commits](https://img.shields.io/github/last-commit/bwireman/gleither)](https://github.com/bwireman/gleither/commit/main)
[![mit](https://img.shields.io/github/license/bwireman/gleither?color=brightgreen)](https://github.com/bwireman/gleither/blob/main/LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](http://makeapullrequest.com)

```sh
gleam add gleither
```
```gleam
import gleither.{Left, Right, map, get}

pub fn main() {
  Left(1)
  |> map(fn(x) { x + 1 })
  |> get()
  // Some(2)
}
```
