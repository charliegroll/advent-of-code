import gleam/int.{add, parse}
import gleam/io
import gleam/iterator.{find, from_list}
import gleam/list.{fold, map}
import gleam/result.{is_ok, unwrap}
import gleam/string.{reverse, split}
import simplifile.{read}

pub fn main() {
  let assert Ok(file) = read("./input")

  let lines = split(file, "\n")
  let digits_list = map(lines, get_first_and_last_digits)

  let res = fold(digits_list, 0, add)
  io.debug(res)
  res
}

fn get_first_and_last_digits(line: String) -> Int {
  let chars = split(line, "")
  let chars_rev = split(reverse(line), "")

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
