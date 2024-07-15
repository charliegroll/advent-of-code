import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile.{read}

// 12 red cubes, 13 green cubes, and 14 blue cubes
const max_list = [#("red", 12), #("green", 13), #("blue", 14)]

pub fn pt1() {
  let assert Ok(file) = read("./input/day2")

  file
  |> string.split("\n")
  // there must be a cleaner way...
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(game_value)
  |> int.sum
}

fn game_value(game_line: String) -> Int {
  let assert Ok(#("Game " <> game_id, sets)) =
    string.split_once(game_line, ": ")
  let assert Ok(game_id) = int.parse(game_id)

  let max_dict = dict.from_list(max_list)

  string.split(sets, "; ")
  |> list.fold(9_999_999, fn(acc, set) {
    string.split(set, ", ")
    |> list.fold_until(game_id, fn(_, cubes) {
      let assert [count, color] = string.split(cubes, " ")
      let assert Ok(count) = int.parse(count)
      let assert Ok(max) = dict.get(max_dict, color)

      case count {
        n if n > max -> list.Stop(0)
        _ -> list.Continue(game_id)
      }
    })
    |> int.min(acc)
  })
}

pub fn pt2() {
  let assert Ok(file) = read("./input/day2")

  file
  |> string.split("\n")
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(compute_cube_power)
  |> int.sum
}

fn compute_cube_power(game_line: String) -> Int {
  let assert Ok(#("Game " <> _game_id, sets)) =
    string.split_once(game_line, ": ")

  let base_cube_dict =
    dict.from_list([#("red", 0), #("blue", 0), #("green", 0)])

  string.split(sets, "; ")
  |> list.fold(base_cube_dict, fn(acc, set) {
    string.split(set, ", ")
    |> list.fold(base_cube_dict, fn(acc, cubes) {
      let assert [count, color] = string.split(cubes, " ")
      let assert Ok(count) = int.parse(count)

      dict.upsert(acc, color, fn(old_count) {
        option.unwrap(old_count, 0)
        |> int.max(count)
      })
    })
    |> dict.combine(acc, int.max)
  })
  |> dict.values
  |> list.reduce(fn(acc, i) { acc * i })
  |> result.unwrap(0)
}
