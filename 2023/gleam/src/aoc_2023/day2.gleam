import gleam/dict
import gleam/int
import gleam/list
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

pub type Game {
  PossibleGame(id: Int)
  ImpossibleGame
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
