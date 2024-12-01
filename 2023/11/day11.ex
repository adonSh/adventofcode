defmodule Day11 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
    end
  end

  def part1(input) do
    input
  end

  def part2(_) do
    0
  end
end
