defmodule Day13 do
  def get_input(file) do
    for line <- file |> IO.read(:eof) |> String.split("\n\n") do
      line
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
    end
  end

  def part1(input) do
    line = input
    |> List.first()
    |> List.first()

    findsymmetry(line)
  end

  def part2(_) do
    0
  end

  defp findsymmetry(line) do
    one = div(length(line), 2) - 1
    two = one + 1
    cond do
      Enum.slice(line, 0..one) == Enum.reverse(Enum.slice(line, one+1..-2)) ->
        one
      Enum.slice(line, 1..two) == Enum.reverse(Enum.slice(line, two+1..-1)) ->
        two
      true ->
        nil
    end
  end
end
