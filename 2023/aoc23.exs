defmodule Main do
  def days("1"), do: Day1
  def days("2"), do: Day2
  def days("3"), do: Day3
  def days("4"), do: Day4
  def days("5"), do: Day5
  def days("6"), do: Day6
  def days("7"), do: Day7
  def days("8"), do: Day8
  def days("9"), do: Day8
  def days("10"), do: Day10
  def days("11"), do: Day11
  def days("12"), do: Day12
  def days("13"), do: Day13
  def days("14"), do: Day14
  def days("15"), do: Day15
  def days("16"), do: Day16
  def days("17"), do: Day17
  def days("18"), do: Day18
  def days("19"), do: Day19
  def days("20"), do: Day20
  def days("21"), do: Day21
  def days("22"), do: Day22
  def days("23"), do: Day23
  def days("24"), do: Day24
  def days("25"), do: Day25

  def do_the_thing(day, file) do
    input = day.get_input(file)
    input |> day.part1() |> IO.inspect()
    input |> day.part2() |> IO.inspect()
  end

  def loop() do
    d = IO.gets("Day? ") |> String.trim()
    {:ok, file} = File.open("#{String.pad_leading(d, 2, "0")}/input.txt")
    Main.do_the_thing(days(d), file)
    File.close(file)
    Main.loop()
  end
end

if length(System.argv) > 0 do
  System.argv |> Enum.at(0) |> Main.days() |> Main.do_the_thing(:stdio)
else
  Main.loop()
end
