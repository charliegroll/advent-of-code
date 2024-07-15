import aoc_2023/day1
import aoc_2023/day2
import gleam/int.{to_string}
import gleam/io

pub fn main() {
  io.println("Day 1")
  io.println("pt1: " <> to_string(day1.pt1()))
  io.println("pt2: " <> to_string(day1.pt2()))

  io.println("Day 2")
  io.println("pt1: " <> to_string(day2.pt1()))
  io.println("pt2: " <> to_string(day2.pt2()))
}
