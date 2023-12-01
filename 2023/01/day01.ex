defmodule Day01 do
  def get_input(file) do
    file
    |> IO.read(:eof)
    |> String.split("\n", trim: true)
  end

  def part1(input) do
    input
    |> Enum.map(&firstlast/1)
    |> Enum.sum()
  end

  def part2(input) do
    for line <- input do
      line
      |> String.replace("one", "o1e")
      |> String.replace("two", "t2o")
      |> String.replace("three", "t3e")
      |> String.replace("four", "f4r")
      |> String.replace("five", "f5e")
      |> String.replace("six", "s6x")
      |> String.replace("seven", "s7n")
      |> String.replace("eight", "e8t")
      |> String.replace("nine", "n9e")
      |> firstlast()
    end
    |> Enum.sum()
  end

  defp firstlast(s) do
    digits = for c <- String.to_charlist(s), ?1 <= c and c <= ?9, do: c - ?0
    case {List.first(digits), List.last(digits)} do
      {nil, nil} -> 0
      {tens, ones} -> tens * 10 + ones
    end
  end
end
