import gleam/int.{parse, sum}
import gleam/iterator.{find, from_list}
import gleam/list.{first, last, map, rest}
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

pub fn pt2() {
  let assert Ok(file) = read("./input/day1")

  file
  |> split("\n")
  |> map(fn(line) { line |> to_graphemes |> get_digits([]) })
  |> map(fn(digits) {
    let assert Ok(res) =
      [first(digits), last(digits)] |> result.values |> int.undigits(10)
    res
  })
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

fn get_digits(chars: List(String), digits: List(Int)) -> List(Int) {
  let next = rest(chars) |> unwrap([])

  case chars {
    [] -> list.reverse(digits)
    ["1", ..] -> get_digits(next, [1, ..digits])
    ["2", ..] -> get_digits(next, [2, ..digits])
    ["3", ..] -> get_digits(next, [3, ..digits])
    ["4", ..] -> get_digits(next, [4, ..digits])
    ["5", ..] -> get_digits(next, [5, ..digits])
    ["6", ..] -> get_digits(next, [6, ..digits])
    ["7", ..] -> get_digits(next, [7, ..digits])
    ["8", ..] -> get_digits(next, [8, ..digits])
    ["9", ..] -> get_digits(next, [9, ..digits])
    ["o", "n", "e", ..] -> get_digits(next, [1, ..digits])
    ["t", "w", "o", ..] -> get_digits(next, [2, ..digits])
    ["t", "h", "r", "e", "e", ..] -> get_digits(next, [3, ..digits])
    ["f", "o", "u", "r", ..] -> get_digits(next, [4, ..digits])
    ["f", "i", "v", "e", ..] -> get_digits(next, [5, ..digits])
    ["s", "i", "x", ..] -> get_digits(next, [6, ..digits])
    ["s", "e", "v", "e", "n", ..] -> get_digits(next, [7, ..digits])
    ["e", "i", "g", "h", "t", ..] -> get_digits(next, [8, ..digits])
    ["n", "i", "n", "e", ..] -> get_digits(next, [9, ..digits])
    _ -> get_digits(unwrap(rest(chars), []), digits)
  }
}
