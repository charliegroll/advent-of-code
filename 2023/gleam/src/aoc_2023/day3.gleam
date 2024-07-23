import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

pub fn pt1() {
  let assert Ok(file) = read("./input/day3")

  file
  |> string.split("\n")
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.flat_map(process_line(_, []))
  |> io.debug
}

pub type EnginePart {
  Part(x: Int, y: Int, number: Int)
  Symbol(x: Int, y: Int, number: Int)
}

fn process_line(line: String, acc: List(EnginePart)) -> List(EnginePart) {
  let rest = string.drop_left(line, 1)
  let #(latest_part, prev_parts) = case list.split(acc, 1) {
    #([], _) -> #(Part(0, 0, 0), [])
    #([l], []) -> #(l, [])
    #([l], prev_parts) -> #(l, prev_parts)
    #(_, _) -> panic as "This can't happen"
  }

  let first_char = string.first(rest)
  case first_char {
    Ok(".") -> process_line(rest, acc)
    Ok(c) ->
      case int.parse(c) {
        Ok(n) -> {
          process_line(rest, [latest_part, ..prev_parts])
        }
        _ -> process_line(rest, acc)
      }
    Error(Nil) -> acc
  }
}
