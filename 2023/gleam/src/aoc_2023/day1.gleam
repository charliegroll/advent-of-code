import gleam/int.{parse, sum}
import gleam/iterator.{find, from_list}
import gleam/list.{map}
import gleam/result.{is_ok, unwrap}
import gleam/string.{reverse, split, to_graphemes}
import simplifile.{read}

pub fn pt1() {
  let assert Ok(file) = read("./input/day1")

  file
  |> split("\n")
  |> map(get_first_and_last_digits)
  |> sum
}

fn get_first_and_last_digits(line: String) -> Int {
  let chars = to_graphemes(line)
  let chars_rev = to_graphemes(reverse(line))

  let digits =
    unwrap(get_first_digit(chars), "") <> unwrap(get_first_digit(chars_rev), "")

  digits
  |> parse
  |> unwrap(0)
}

fn get_first_digit(line: List(String)) -> Result(String, Nil) {
  let it = from_list(line)

  find(it, fn(c) {
    let i = parse(c)

    is_ok(i)
  })
}
