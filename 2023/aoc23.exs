defmodule Main do
  def days(1), do: Day01
  def days(2), do: Day02
  def days(3), do: Day03
  def days(4), do: Day04
  def days(5), do: Day05
  def days(6), do: Day06
  def days(7), do: Day07
  def days(8), do: Day08
  def days(9), do: Day09
  def days(10), do: Day10
  def days(11), do: Day11
  def days(12), do: Day12
  def days(13), do: Day13
  def days(14), do: Day14
  def days(15), do: Day15
  def days(16), do: Day16
  def days(17), do: Day17
  def days(18), do: Day18
  def days(19), do: Day19
  def days(20), do: Day20
  def days(21), do: Day21
  def days(22), do: Day22
  def days(23), do: Day23
  def days(24), do: Day24
  def days(25), do: Day25

  def solve(day, file) do
    input = day.get_input(file)
    input |> day.part1() |> IO.inspect()
    input |> day.part2() |> IO.inspect()
  end

  def loop() do
    d =
      case IO.gets("> ") |> String.trim() do
        "q" -> System.halt(0)
        "" -> loop()
        n -> n
      end
    {:ok, file} = File.open("#{String.pad_leading(d, 2, "0")}/input.txt")
    d |> String.to_integer() |> days() |> solve(file)
    File.close(file)
    loop()
  end
end

case List.first(System.argv) do
  nil -> Main.loop()
  d -> d |> String.to_integer() |> Main.days() |> Main.solve(:stdio)
end
